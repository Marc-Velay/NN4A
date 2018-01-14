/*

	spatial.cpp

	Spatialisation d'une source mono en une source stéréo.
	
*/


// ----- en-têtes C,C++

#include <math.h>
#include <iostream.h>
#include <stdio.h>
#include <stdlib.h>

#include "3dsound.h"


// ----- fonction mex

#include "mex.h"


// ----- en-têtes toolbox RdF et SpecRdF

void  spatial(double *, const double *, int, int, int, int, int);

 
// ----- usage 

#define usage "usage : StereoSignal = spatial(MonoSignal, XSource, YSource, XHead, YHead)"
 


void mexFunction(int nargout, mxArray *argout[], int nargin, const mxArray *argin[])
{

	if (nargin!=5)
		mexErrMsgTxt(usage);

// 5 arguments : spatialisation du signal :	
	else
	{	
		const mxArray *signal	= argin[0];     // signal original
		const mxArray *pxs		= argin[1];		// x source
		const mxArray *pys		= argin[2];		// y source
		const mxArray *pxh		= argin[3];		// x tête
		const mxArray *pyh		= argin[4];		// y tête

	// dimensions :
		double xs		= (int) *mxGetPr(pxs);		// 
		double ys		= (int) *mxGetPr(pys);		// 
		double xh		= (int) *mxGetPr(pxh);		// 
		double yh		= (int) *mxGetPr(pyh);		// 
		
		int siglength	= mxGetN(signal);		// nombre d'échantillons du signal
		int channels	= mxGetM(signal);		// nombre de voies 1=mono, 2=stéréo)

	// controle données : 
		if (channels==2)
			mexErrMsgTxt("[spatial.cpp] erreur : le signal d'entrée doit être mono (une voie).");

	// valeurs de retour :
		mxArray *SPsignal = mxCreateDoubleMatrix(2, siglength, mxREAL); 

	// pointeurs data :
		const double *Psignal	= mxGetPr(signal);
		double *PSPsignal		= mxGetPr(SPsignal);

	// spatialisation du signal :
		spatial(PSPsignal, Psignal, siglength, 
			(int) floor(xs), (int) floor(ys), (int) floor(xh), (int) floor(yh));
	
		argout[0] = SPsignal;
	}
}


 


#define __NO_MATH_INLINES


/* room and propagation model */
#define wallReflection 0.6f	/* energy reflected from wall */
#define roomScale 30.0f		/* pixels per foot */
#define soundVelocity 1148.0f	/* feet per second */
#define propDelay (SRateOut / soundVelocity / roomScale)	/* samples per pixel */

/* miscellaneous definitions */
#define PI 3.14159265f
#define limitPI(x) ((x) > PI) ? ((x) - 2 * PI) : (((x) < -PI) ? ((x) + 2 * PI) : (x))
#define transformSize 512

/* pinna model */
#define f1 2000.0f		/* corner frequency of IID, see Begault pg 41 */
#define f2 (SRateOut / 2.0f)	/* Nyquist frequency */
#define maxGain 3.1623f		/* 10 dB gain, see Begault pg 62 */
#define maxAcuity PI / 4	/* angle of maximum high frequency content */

/* define structure to hold taps for filter elements at various azimuths */
#define maxTaps 7

#define inbufsize	2048
#define outbufsize	NChannelsOut * sizeof(short) * inbufsize


struct filterElements 
{
    int totalTaps;
    filterTap tap[maxTaps];
};


/* local prototypes */
void addFilter(POINT * sourcePt, POINT * headCenter, float fRange,
	       float *leftFilter, float *rightFilter);
void convolve(struct filterElements *filter1,
	      struct filterElements *filter2, float *filterOut,
	      float fAtten, int nDelay);
void C_FFT(struct cpxFloat *data, int N, int ISI);


/* global variables */
/* structure to hold constant filters */
struct filterElements weights[19], acuity[19];

/* pointers to double buffers used for spatialization */
float *thisFrame, *lastFrame;

/* pointers to raw filters from which composite filters are produced */
float *rawFilterL, *rawFilterR;

/* these variables put here to make them readable by other programs */
/* structure to hold composite tap weights for synthesis */
struct compositeFilter filterL, filterR;

/* positions of 1st order reflections in room model */
POINT topPt, bottomPt, leftPt, rightPt;
float fAzimuth, fRange;



/********************************************************/

void  spatial(double *outsig, const double *insig, int siglength, int sx, int sy, int hx, int hy)
{
    char buf[2048];
    POINT headCenter, sourcePt;
    RECT roomModel;
    short sndbuf[inbufsize];
    short outbuf[outbufsize];

    roomModel.left = 0;
    roomModel.top = 0;
    roomModel.right = 640;
    roomModel.bottom = 480;

    headCenter.x = hx;
    headCenter.y = hy;

    sourcePt.x = sx;
    sourcePt.y = sy;  

    /* init soundscape */
    soundscapeInit(inbufsize);
    soundscapeUpdate(&sourcePt, &headCenter, &roomModel, inbufsize);

    sprintf(buf,
	    "Azim. %d, range %3.1f, L(%d taps, last %d), R(%d taps, last %d) (%ld,%ld)",
	    (int) (fAzimuth * 180.0f / 3.14159265f),	/* in degrees */
		fRange,	/* in pixels */
		filterL.totalTaps,
		filterL.tap[filterL.totalTaps - 1].delay,
		filterR.totalTaps,
		filterR.tap[filterR.totalTaps - 1].delay, sourcePt.x,
		sourcePt.y
	);
	mexPrintf("%s\n",buf);	

// normalisation du signal
	int i;
	double minval=insig[0], maxval=insig[0], maxabs;

	for (i=0; i<siglength; i++)
		insig[i]<minval? minval=insig[i] : (insig[i]>maxval? maxval=insig[i] : 1);
	maxabs = -minval > maxval? -minval : maxval;
	
	int offset;
	for (offset=0; offset<siglength-inbufsize; offset += inbufsize)
	{
		for (i=0; i<inbufsize; i++)
			sndbuf[i] = (short) ((insig[offset+i]/maxabs)*20000.0);

// spatialize the mono input sound 
		spatialize(sndbuf, outbuf, inbufsize);
		
		for (i=0; i<inbufsize*2; i++)
			outsig[offset*2+i] = (((double) outbuf[i])/20000)*maxabs;		
	}

	/* we are here because stdin is empty */
    soundscapeFree();    
}







/********************************************************/

void soundscapeInit(int numSamples)
{
    int i, j, k, m;
    float fTemp1, azimuth;
    struct cpxFloat C_FFTdata[transformSize];

/* allocate double buffers for input speech */
    thisFrame = (float *) malloc(numSamples * sizeof(float));
    lastFrame = (float *) malloc(numSamples * sizeof(float));

/* allocate rawFilters for left and right ear */
    rawFilterL = (float *) malloc(numSamples * sizeof(float));
    rawFilterR = (float *) malloc(numSamples * sizeof(float));

/*********************************************************/
/*         differential cues for sound location          */
/*  These are filters applied to the shadowed ear, while */
/*   the unshadowed ear receives the unfiltered sound.   */
/*********************************************************/
    weights[0].totalTaps = 1;
    weights[0].tap[0].delay = 0;
    weights[0].tap[0].weight = 1.0f;
    weights[1].totalTaps = 1;
    weights[1].tap[0].delay = 1;
    weights[1].tap[0].weight = 0.7464f;
    weights[2].totalTaps = 3;
    weights[2].tap[0].delay = 1;
    weights[2].tap[0].weight = 0.0814f;
    weights[2].tap[1].delay = 2;
    weights[2].tap[1].weight = 0.5577f;
    weights[2].tap[2].delay = 9;
    weights[2].tap[2].weight = 0.0755f;
    weights[3].totalTaps = 3;
    weights[3].tap[0].delay = 2;
    weights[3].tap[0].weight = 0.1034f;
    weights[3].tap[1].delay = 3;
    weights[3].tap[1].weight = 0.4221f;
    weights[3].tap[2].delay = 4;
    weights[3].tap[2].weight = 0.0812f;
    weights[4].totalTaps = 4;
    weights[4].tap[0].delay = 3;
    weights[4].tap[0].weight = 0.1137f;
    weights[4].tap[1].delay = 4;
    weights[4].tap[1].weight = 0.3350f;
    weights[4].tap[2].delay = 5;
    weights[4].tap[2].weight = 0.0777f;
    weights[4].tap[3].delay = 8;
    weights[4].tap[3].weight = 0.0918f;
    weights[5].totalTaps = 4;
    weights[5].tap[0].delay = 4;
    weights[5].tap[0].weight = 0.1199f;
    weights[5].tap[1].delay = 5;
    weights[5].tap[1].weight = 0.2839f;
    weights[5].tap[2].delay = 8;
    weights[5].tap[2].weight = 0.0814f;
    weights[5].tap[3].delay = 9;
    weights[5].tap[3].weight = 0.0945f;
    weights[6].totalTaps = 4;
    weights[6].tap[0].delay = 5;
    weights[6].tap[0].weight = 0.1394f;
    weights[6].tap[1].delay = 6;
    weights[6].tap[1].weight = 0.2469f;
    weights[6].tap[2].delay = 8;
    weights[6].tap[2].weight = 0.1090f;
    weights[6].tap[3].delay = 9;
    weights[6].tap[3].weight = 0.1243f;
    weights[7].totalTaps = 4;
    weights[7].tap[0].delay = 6;
    weights[7].tap[0].weight = 0.1759f;
    weights[7].tap[1].delay = 7;
    weights[7].tap[1].weight = 0.2168f;
    weights[7].tap[2].delay = 8;
    weights[7].tap[2].weight = 0.0745f;
    weights[7].tap[3].delay = 9;
    weights[7].tap[3].weight = 0.1485f;
    weights[8].totalTaps = 2;
    weights[8].tap[0].delay = 7;
    weights[8].tap[0].weight = 0.2691f;
    weights[8].tap[1].delay = 8;
    weights[8].tap[1].weight = 0.2398f;
    weights[9].totalTaps = 2;
    weights[9].tap[0].delay = 7;
    weights[9].tap[0].weight = 0.1495f;
    weights[9].tap[1].delay = 8;
    weights[9].tap[1].weight = 0.3986f;
    weights[10].totalTaps = 6;
    weights[10].tap[0].delay = 6;
    weights[10].tap[0].weight = 0.0871f;
    weights[10].tap[1].delay = 7;
    weights[10].tap[1].weight = 0.1206f;
    weights[10].tap[2].delay = 8;
    weights[10].tap[2].weight = 0.2940f;
    weights[10].tap[3].delay = 9;
    weights[10].tap[3].weight = 0.1386f;
    weights[10].tap[4].delay = 10;
    weights[10].tap[4].weight = -0.0878f;
    weights[10].tap[5].delay = 11;
    weights[10].tap[5].weight = 0.0812f;
    weights[11].totalTaps = 5;
    weights[11].tap[0].delay = 6;
    weights[11].tap[0].weight = 0.2230f;
    weights[11].tap[1].delay = 8;
    weights[11].tap[1].weight = 0.1485f;
    weights[11].tap[2].delay = 9;
    weights[11].tap[2].weight = 0.2420f;
    weights[11].tap[3].delay = 10;
    weights[11].tap[3].weight = -0.1406f;
    weights[11].tap[4].delay = 11;
    weights[11].tap[4].weight = 0.0947f;
    weights[12].totalTaps = 4;
    weights[12].tap[0].delay = 5;
    weights[12].tap[0].weight = 0.2107f;
    weights[12].tap[1].delay = 6;
    weights[12].tap[1].weight = 0.1771f;
    weights[12].tap[2].delay = 8;
    weights[12].tap[2].weight = 0.1855f;
    weights[12].tap[3].delay = 9;
    weights[12].tap[3].weight = 0.0945f;
    weights[13].totalTaps = 6;
    weights[13].tap[0].delay = 4;
    weights[13].tap[0].weight = 0.1722f;
    weights[13].tap[1].delay = 5;
    weights[13].tap[1].weight = 0.3069f;
    weights[13].tap[2].delay = 6;
    weights[13].tap[2].weight = -0.0947f;
    weights[13].tap[3].delay = 7;
    weights[13].tap[3].weight = 0.1744f;
    weights[13].tap[4].delay = 9;
    weights[13].tap[4].weight = 0.1507f;
    weights[13].tap[5].delay = 10;
    weights[13].tap[5].weight = 0.0725f;
    weights[14].totalTaps = 6;
    weights[14].tap[0].delay = 3;
    weights[14].tap[0].weight = 0.1411f;
    weights[14].tap[1].delay = 4;
    weights[14].tap[1].weight = 0.4134f;
    weights[14].tap[2].delay = 5;
    weights[14].tap[2].weight = -0.0851f;
    weights[14].tap[3].delay = 6;
    weights[14].tap[3].weight = 0.1297f;
    weights[14].tap[4].delay = 9;
    weights[14].tap[4].weight = 0.1275f;
    weights[14].tap[5].delay = 10;
    weights[14].tap[5].weight = 0.0715f;
    weights[15].totalTaps = 5;
    weights[15].tap[0].delay = 2;
    weights[15].tap[0].weight = 0.0969f;
    weights[15].tap[1].delay = 3;
    weights[15].tap[1].weight = 0.5380f;
    weights[15].tap[2].delay = 4;
    weights[15].tap[2].weight = -0.0723f;
    weights[15].tap[3].delay = 5;
    weights[15].tap[3].weight = 0.1061f;
    weights[15].tap[4].delay = 9;
    weights[15].tap[4].weight = 0.0967f;
    weights[16].totalTaps = 3;
    weights[16].tap[0].delay = 2;
    weights[16].tap[0].weight = 0.6658f;
    weights[16].tap[1].delay = 4;
    weights[16].tap[1].weight = 0.0730f;
    weights[16].tap[2].delay = 9;
    weights[16].tap[2].weight = 0.0861f;
    weights[17].totalTaps = 1;
    weights[17].tap[0].delay = 1;
    weights[17].tap[0].weight = 0.8155f;
    weights[18].totalTaps = 1;
    weights[18].tap[0].delay = 0;
    weights[18].tap[0].weight = 1.0f;

/*********************************************************/
/*          common mode cues for sound location          */
/*  These are filters applied to both ears in order to   */
/*      create a cue for front-back discrimination.      */
/*********************************************************/
/* create 18 filters for azimuth 0 to 180 deg. in steps of 10 deg. */
    for (i = 0; i < 19; i++) {
	azimuth = PI * (float) i / 18.0f;

/*
 * Gain of the filter at the Nyquist frequency f2 is defined as
 * X = maxGain**cos(azimuth), where maxGain is the gain at 
 * 0 deg. azimuth relative to the gain at 90 deg.  Taking logs 
 * and solving for X gives X = exp(log(maxGain) * cos(azimuth)).
 * Gain at corner frequency f1 and below is 1.0.  Between f1 and f2, 
 * Gain as a function of frequency f follows the exponential curve 
 * (linear log curve) Gain = exp(k * (f - f1) / (f2 - f1)).
 * Since Gain = X when f = f2, k = log(maxGain) * cos(azimuth).
 */
	for (j = 0; j < transformSize; j++) {
	    C_FFTdata[j].re = 0.0;
	    C_FFTdata[j].im = 0.0;
	}
	for (j = 0; j <= transformSize / 2; j++) {
	    fTemp1 = f2 * (float) j / ((float) transformSize / 2.0f);
	    C_FFTdata[j].re = 1.0;	/* unity gain */
	    if (fTemp1 > f1)
		C_FFTdata[j].re =
		    (float) exp(cos(azimuth) * log(maxGain) *
				(fTemp1 - f1) / (f2 - f1));
	}
/* mirror the upper half */
	for (j = transformSize / 2; j < transformSize; j++) {
	    C_FFTdata[j].re = C_FFTdata[transformSize - j].re;
	}

/* convert filter to time domain */
	C_FFT(C_FFTdata, transformSize, -1);

/* create filter taps for fabs(elements) >= 0.05 */
	acuity[i].totalTaps = 0;
	m = 0;
	for (j = 0; j < 7; j++) {
	    k = j + 509;	/* shift the result a bit */
	    if (k >= transformSize)
		k -= transformSize;
	    if (fabs(C_FFTdata[k].re / transformSize) >= 0.05) {
		acuity[i].totalTaps++;
		acuity[i].tap[m].delay = 6 - j;	/* for convolution */
		acuity[i].tap[m++].weight =
		    C_FFTdata[k].re / transformSize;}
	}
    }

/* place sound source in middle of head */
    filterL.totalTaps = 1;
    filterL.tap[0].delay = 0;
    filterL.tap[0].weight = 1.0;
    filterR.totalTaps = 1;
    filterR.tap[0].delay = 0;
    filterR.tap[0].weight = 1.0;
}


/********************************************************/

void soundscapeFree()
{
    if (thisFrame != NULL)
		free(thisFrame);
    if (lastFrame != NULL)
		free(lastFrame);
    if (rawFilterL != NULL)
		free(rawFilterL);
    if (rawFilterR != NULL)
		free(rawFilterR);
}


/********************************************************/

void soundscapeUpdate(POINT * sourcePt, POINT * headCenter,
		      RECT * roomModel, int inBufSize)
{
    int i, j, nAzimuthIndex, nIndexL, nIndexR, nTapL, nTapR;
    float fAccumulator;
    float fTemp1, fTemp2;

/* fAzimuth and fRange are global variables */

/* left and right ear filters are convolutions of individual filters */
/* for the direct source ray and all room reflections */

/* initialize convolution to 0 */
    for (i = 0; i < inBufSize; i++) {
	rawFilterL[i] = 0.0;
	rawFilterR[i] = 0.0;
    }

/* calculate azimuth and range of direct ray */
    fTemp1 = (float) (sourcePt->y - headCenter->y);
    fTemp2 = (float) (sourcePt->x - headCenter->x);
    fAzimuth = (float) atan2((fTemp1), (fTemp2));
    fRange = (float) sqrt(fTemp1 * fTemp1 + fTemp2 * fTemp2);

/* azimuth index defines azimuth in 10 deg. steps */
    nAzimuthIndex = (int) (fabs(fAzimuth) * 18.0 / PI);

/* differential mode cues are applied only to the shadowed ear */
    nIndexL = 0;
    nIndexR = 0;
    if (fAzimuth > 0.0)
	nIndexL = nAzimuthIndex;	/* sound to right of subject */
    else
	nIndexR = nAzimuthIndex;	/* sound to left of subject */

/* common mode cues (for front - back discrimination) are applied to both ears */
/* right ear */
    fAccumulator = limitPI(fAzimuth - maxAcuity);	/* limit to +- PI */
    nTapR = (int) (fabs(fAccumulator) * 18.0 / PI);

/* left ear */
    fAccumulator = limitPI(fAzimuth + maxAcuity);
    nTapL = (int) (fabs(fAccumulator) * 18.0 / PI);

/* convolve filters representing direct ray */
/* left ear */
    convolve(&weights[nIndexL],	/* right-left differences */
	     &acuity[nTapL],	/* pinna frequency shaping (front-back) */
	     rawFilterL,	/* composite filter after convolution */
	     1.0,		/* direct ray is not attenuated */
	     0);		/* delay of direct ray subtracted from all filters */
/* right ear */
    convolve(&weights[nIndexR], &acuity[nTapR], rawFilterR, 1.0, 0);

/* calculate positions of mirror image sources for first reflections */
    topPt.x = sourcePt->x;
    topPt.y = -sourcePt->y + 2 * roomModel->top;
    leftPt.x = -sourcePt->x + 2 * roomModel->left;
    leftPt.y = sourcePt->y;
    rightPt.x = 2 * roomModel->right - sourcePt->x;
    rightPt.y = sourcePt->y;
    bottomPt.x = sourcePt->x;
    bottomPt.y = 2 * roomModel->bottom - sourcePt->y;

/* calculate azimuths and differential delays (in samples) of first order  */
/* reflected sounds and add the reflected sources to the synthesis filter */
    addFilter(&topPt, headCenter, fRange, rawFilterL, rawFilterR);
    addFilter(&leftPt, headCenter, fRange, rawFilterL, rawFilterR);
    addFilter(&rightPt, headCenter, fRange, rawFilterL, rawFilterR);
    addFilter(&bottomPt, headCenter, fRange, rawFilterL, rawFilterR);

/* prune filters and transfer to synthesis filters */
/* allow filter tap delays up to half the speech buffer size */
    filterL.totalTaps = 0;
    j = 0;
    for (i = 0; i < inBufSize / 2; i++) {
	if (fabs(rawFilterL[i]) > 0.01) {
	    filterL.totalTaps++;
	    filterL.tap[j].delay = i;
	    filterL.tap[j++].weight = rawFilterL[i];
	}
    }
    filterR.totalTaps = 0;
    j = 0;
    for (i = 0; i < inBufSize / 2; i++) {
	if (fabs(rawFilterR[i]) > 0.01) {
	    filterR.totalTaps++;
	    filterR.tap[j].delay = i;
	    filterR.tap[j++].weight = rawFilterR[i];
	}
    }
}



/********************************************************/

void spatialize(short *sBuffer, short *outBuffer, int numSamples)
{
    int j, k, m;
    float fAccumulator, *swap;

/* convert thisFrame of input shorts to float */
    for (j = 0; j < numSamples; j++)
	thisFrame[j] = sBuffer[j];

/* synthesize one pair of stereo samples per input sample */

/* left channel composite signal */
/* delay of taps is in ascending order */
/* for j < filterL.tap[filterL.totalTaps - 1].delay, samples from thisFrame and lastFrame */
/* samples stored in outBuffer in order L R L R ... */
    for (j = 0; j < filterL.tap[filterL.totalTaps - 1].delay; j++) {
	fAccumulator = 0.0f;
	for (k = 0; k < filterL.totalTaps; k++) {
	    m = j - filterL.tap[k].delay;
	    if (m < 0) {	/* detect whether sample comes from lastFrame */
		m += numSamples;
		fAccumulator += lastFrame[m] * filterL.tap[k].weight;
	    }

	    else
		fAccumulator += thisFrame[m] * filterL.tap[k].weight;
	}
	outBuffer[NChannelsOut * j] = (short) fAccumulator;
    }
/* samples now guaranteed to come from thisFrame */
    for (j = filterL.tap[filterL.totalTaps - 1].delay; j < numSamples; j++) {
	fAccumulator = 0.0f;
	for (k = 0; k < filterL.totalTaps; k++) {
	    fAccumulator +=
		thisFrame[j -
			  filterL.tap[k].delay] * filterL.tap[k].weight;}
	outBuffer[NChannelsOut * j] = (short) fAccumulator;
    }
/* right channel composite signal */
    for (j = 0; j < filterR.tap[filterR.totalTaps - 1].delay; j++) {
	fAccumulator = 0.0f;
	for (k = 0; k < filterR.totalTaps; k++) {
	    m = j - filterR.tap[k].delay;
	    if (m < 0) {	/* detect whether sample comes from lastFrame */
		m += numSamples;
		fAccumulator += lastFrame[m] * filterR.tap[k].weight;
	    }

	    else
		fAccumulator += thisFrame[m] * filterR.tap[k].weight;
	}
	outBuffer[NChannelsOut * j + 1] = (short) fAccumulator;
    }
/* samples now guaranteed to come from thisFrame */
    for (j = filterR.tap[filterR.totalTaps - 1].delay; j < numSamples; j++) {
	fAccumulator = 0.0f;
	for (k = 0; k < filterR.totalTaps; k++) {
	    fAccumulator +=
		thisFrame[j -
			  filterR.tap[k].delay] * filterR.tap[k].weight;}
	outBuffer[NChannelsOut * j + 1] = (short) fAccumulator;
    }
/* thisFrame now becomes lastFrame */
    swap = thisFrame;
    thisFrame = lastFrame;
    lastFrame = swap;
} void addFilter(POINT * sourcePt, POINT * headCenter,
		 float directRayRange, float *leftEarFilter,
		 float *rightEarFilter)
{
    int nAzimuthIndex, nIndexL, nIndexR, nTapL, nTapR, nDelay;
    float reflRayRange, relativeAzimuth, azimuth, atten;
    float fTemp1, fTemp2;

/* calculate azimuth and range of reflected ray */
    fTemp1 = (float) (sourcePt->y - headCenter->y);
    fTemp2 = (float) (sourcePt->x - headCenter->x);
    azimuth = (float) atan2((fTemp1), (fTemp2));	/* azimuth of virtual source */
    reflRayRange = (float) sqrt(fTemp1 * fTemp1 + fTemp2 * fTemp2);	/* range to virtual source */

/* azimuth index defines azimuth in 10 deg. steps */
    nAzimuthIndex = (int) (fabs(azimuth) * 18.0 / PI);

/* differential mode cues are applied only to the shadowed ear */
    nIndexL = 0;
    nIndexR = 0;
    if (azimuth > 0.0)
	nIndexL = nAzimuthIndex;	/* sound to right of subject */
    else
	nIndexR = nAzimuthIndex;	/* sound to left of subject */

/* common mode cues (for front - back discrimination) are applied to both ears */
    /* right ear */
    relativeAzimuth = limitPI(azimuth - maxAcuity);
    nTapR = (int) (fabs(relativeAzimuth) * 18.0 / PI);

    /* left ear */
    relativeAzimuth = limitPI(azimuth + maxAcuity);
    nTapL = (int) (fabs(relativeAzimuth) * 18.0 / PI);

/* delay = DIFFERENCE in delay relative to direct ray */
    nDelay = (int) ((reflRayRange - directRayRange) * propDelay);

/* attenuation = squared ratio of ranges of direct and reflected ray */
    atten =
	wallReflection * directRayRange * directRayRange / reflRayRange /
	reflRayRange;
/* add the filter */
/* left ear */
    convolve(&weights[nIndexL], &acuity[nTapL], leftEarFilter, atten, nDelay);	/* differential delay is built into weights */
/* right ear */
    convolve(&weights[nIndexR], &acuity[nTapR], rightEarFilter, atten,
	     nDelay);
} void convolve(struct filterElements *filter1,
		struct filterElements *filter2,
		float *filterOut, float fAtten, int nDelay)
{
    int i, j, k;

/* sum delays, multiply weights */
    for (i = 0; i < filter1->totalTaps; i++) {
	for (j = 0; j < filter2->totalTaps; j++) {
	    k = filter1->tap[i].delay + filter2->tap[j].delay + nDelay;

/* add new element of convolution to sum for that tap */
	    filterOut[k] +=
		filter1->tap[i].weight * filter2->tap[j].weight * fAtten;
	}
    }
}



/********************************************************/

void C_FFT(struct cpxFloat *data, int N, int ISI)
{
    int i, j, m, mmax, istep;
    struct cpxFloat cfTemp;
    struct cpxDouble cdTemp1, cdTemp2;
    double theta, pi = 3.14159265358979323846264338327, dTemp;

    /*
     * first operation puts data in bit-reversed order 
     */
    j = 0;
    for (i = 0; i < N; i++) {
		if (i < j) {
		    cfTemp.re = data[j].re;
		    cfTemp.im = data[j].im;
		    data[j].re = data[i].re;
			data[j].im = data[i].im;
			data[i].re = cfTemp.re;
		    data[i].im = cfTemp.im;
		}
		m = N / 2;
		while (j >= m) {
			j = j - m;
			m = m / 2;
			if (m == 0)
			break;
		}
		j = j + m;
    }

    /*
     * second operation computes the butterflies 
     */
    mmax = 1;
    while (mmax < N) 
	{
		istep = 2 * mmax;
		theta = pi * ISI / mmax;
		dTemp = sin(theta / 2.0);
		cdTemp2.re = -2.0 * dTemp * dTemp;
		cdTemp2.im = sin(theta);
		cdTemp1.re = 1.0;
		cdTemp1.im = 0.0;
		for (m = 0; m < mmax; m++) 
		{
			for (i = m; i < N; i += istep) 
			{
				j = i + mmax;
				cfTemp.re =
					(float) (cdTemp1.re * data[j].re - cdTemp1.im * data[j].im);
				cfTemp.im =
					(float) (cdTemp1.re * data[j].im + cdTemp1.im * data[j].re);
				data[j].re = data[i].re - cfTemp.re;
				data[j].im = data[i].im - cfTemp.im;
				data[i].re += cfTemp.re;
				data[i].im += cfTemp.im;
			}
			dTemp = cdTemp1.re;
			cdTemp1.re =
			cdTemp1.re * cdTemp2.re - cdTemp1.im * cdTemp2.im +
			cdTemp1.re;
			cdTemp1.im =
			cdTemp1.im * cdTemp2.re + dTemp * cdTemp2.im + cdTemp1.im;
		}
		mmax = istep;
    }
}







