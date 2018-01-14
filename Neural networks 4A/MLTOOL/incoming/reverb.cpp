/*

	reverb.cpp

	Effet de réverbération appliqué à un signal audio mono ou stéréo.
	La réponse impulsionnelle est tirée du cours Multimédia de 
	Sylvain Machel.
	
*/


// ----- en-têtes C,C++

#include <math.h>
#include <iostream.h>


// ----- fonction mex

#include "mex.h"


// ----- en-têtes toolbox RdF et SpecRdF

int  reverb(double *, const double *, int, int, double, double);
void mkreponse(double *, int);

// ----- usage 

#define usage "usage : RVSignal = reverb(Signal, Delay, Gain)"


// ----- réponse impulsionnelle du filtre :

#define REP_IMPULSE_X0			52
#define REP_IMPULSE_Y0			1362
#define REP_IMPULSE_LENGTH		82

int rep_impulse_x[] = {
	193, 334, 447, 571, 620, 661, 681, 702, 733, 761, 781, 816,  \
	843, 878, 919, 936, 950, 988, 1009,1029,1063,1074,1109,1126, \
	1156,1177,1198,1218,1229,1243,1263,1290,1311,1339,1363,1397, \
	1425,1460,1480,1514,1545,1566,1594,1614,1645,1680,1697,1724, \
	1748,1778,1804,1831,1872,1914,1938,1965,1976,1999,2020,2048, \
	2062,2089,2113,2134,2155,2179,2199,2220,2240,2268,2282,2303, \
	2327,2344,2368,2371,2409,2427,2457,2495,2516,2554};

int rep_impulse_y[] = {
	653, 739, 756, 843, 901, 928, 908, 915, 990, 908, 994, 977,  \
	1001,956, 1021,1101,1056,1077,1035,1097,1063,1097,1114,1201, \
	1114,1080,1184,1135,1128,1201,1128,1197,1235,1170,1142,1190, \
	1224,1190,1235,1180,1201,1283,1256,1190,1201,1263,1211,1245, \
	1290,1304,1263,1283,1280,1304,1304,1304,1283,1311,1311,1294, \
	1311,1297,1304,1280,1297,1311,1311,1311,1297,1318,1318,1324, \
	1331,1331,1331,1331,1324,1324,1324,1324,1324,1335};
 

void mexFunction(int nargout, mxArray *argout[], int nargin, const mxArray *argin[])
{

// sans argument, retourne la réponse impulsionnelle :
	if (nargin==0)
	{	
		int sizerep = rep_impulse_x[REP_IMPULSE_LENGTH-1]-REP_IMPULSE_X0+1;
		mxArray *rep_impulse = mxCreateDoubleMatrix(1,sizerep, mxREAL);
		double *ptr = mxGetPr(rep_impulse);

		mkreponse(ptr, sizerep);

		argout[0] = rep_impulse;
	}
	else if (nargin!=3)
		mexErrMsgTxt(usage);

// 3 arguments : calcul la réverbération du signal :	
	else
	{	
		const mxArray *signal	= argin[0];     // signal original
		const mxArray *pdelay	= argin[1];		// temps de réverbération
		const mxArray *pgain	= argin[2];     // gain réverbération

	// dimensions :
		double gain		= *mxGetPr(pgain);		// gain réverbération
		double delay	= *mxGetPr(pdelay);		// temps de réverbération
		int siglength	= mxGetN(signal);		// nombre d'échantillons du signal
		int channels	= mxGetM(signal);		// nombre de voies 1=mono, 2=stéréo)

	// controle données : 
		if (channels!=1 && channels!=2)
			mexErrMsgTxt("[reverb.cpp] erreur : nombre de voies incohérent (ni 1, ni 2). (transposer le signal?).");
		else if(delay<1)
			mexErrMsgTxt("[reverb.cpp] erreur : l'argument 'delay' doit être supérieur ou égal à 1.");

	// valeurs de retour :
		mxArray *RVsignal = mxCreateDoubleMatrix(channels, siglength, mxREAL); 

	// pointeurs data :
		const double *Psignal	= mxGetPr(signal);
		double *PRVsignal		= mxGetPr(RVsignal);

	// filtrage du signal :
		reverb(PRVsignal, Psignal, siglength, channels, delay, gain);
	
		argout[0] = RVsignal;
	}
}


 
int reverb(double *rvsignal, const double *signal, int siglength, int channels, double delay, double gain)
{

	int i, k;
	int sizerep = (rep_impulse_x[REP_IMPULSE_LENGTH-1]-REP_IMPULSE_X0)*int(floor(delay)+1);
	int *x = new int [REP_IMPULSE_LENGTH];
	double *y = new double [REP_IMPULSE_LENGTH];
	
// dilatation échelle des temps :
	for (i=0; i<REP_IMPULSE_LENGTH; i++)
		x[i] = (rep_impulse_x[i] - REP_IMPULSE_X0)*int(floor(delay));
		
// charge rep. impulsionnelle et cherche son max : 
	double maxval = 0, buff;
	for (i=0; i<REP_IMPULSE_LENGTH; i++)
	{
		buff = double(REP_IMPULSE_Y0 - rep_impulse_y[i]);
		buff>maxval? maxval=buff : 1; 
 		y[i] = buff;
	}

// normalisation à 1 et gain :
	gain /= maxval; 
	for (i=0; i<REP_IMPULSE_LENGTH; i++)
		y[i] *= gain;

// convolution (signal mono) :
	if (channels==1)
	{
		double rvb;							

	// si la rep. est + longue que le signal !!! :
		int imax = sizerep>siglength? siglength : sizerep;
	
	// fenêtrage : le signal à t<0 vaut zéro
		for (i=0; i<imax; i++)			 
		{
			rvb = 0;
			for (k=REP_IMPULSE_LENGTH-1; k>=0; k--)
				if (i-x[k] >= 0)
					rvb += y[k]*signal[i-x[k]];
			rvsignal[i] = signal[i] + rvb;
		}

	// reste du signal :
		for (i=sizerep+1; i<siglength; i++) 
		{
			rvb = 0;

			for (k=REP_IMPULSE_LENGTH-1; k>=0; k--)
				rvb += y[k]*signal[i-x[k]];
			rvsignal[i] = signal[i] + rvb;
		}
	}

// convolution (signal stéréo) :
	else
	{
		double rvbG, rvbD;

	// si la rep. est + longue que le signal !!! :
		int imax = sizerep>siglength? siglength : sizerep;

	// fenêtrage : le signal à t<0 vaut zéro
		for (i=0; i<imax; i++)			
		{
			rvbG = rvbD = 0;
			for (k=REP_IMPULSE_LENGTH-1; k>=0; k--)
				if (i-x[k] >= 0)
				{
					rvbG += y[k]*signal[2*(i-x[k])];
					rvbD += y[k]*signal[2*(i-x[k])+1];
				}
			rvsignal[2*i]	= signal[2*i] + rvbG;
			rvsignal[2*i+1] = signal[2*i+1] + rvbD;
		}

	// reste du signal :
		for (i=sizerep+1; i<siglength; i++)
		{
			rvbG = rvbD = 0;
			for (k=REP_IMPULSE_LENGTH-1; k>=0; k--)
			{
				rvbG += y[k]*signal[2*(i-x[k])];
				rvbD += y[k]*signal[2*(i-x[k])+1];
			}
			rvsignal[2*i]	= signal[2*i] + rvbG;
			rvsignal[2*i+1] = signal[2*i+1] + rvbD;
		}
	}

	delete [] x;
	delete [] y;
	
	return sizerep;
}



void mkreponse(double *reponse, int sizerep)
{
	int i;

// init. à 0 :
	for (i=0; i<sizerep; i++)
		reponse[i] = 0;

// calcul de la réponse impulsionnelle et recherche de son max :
	double buff, maxval=0;
	for (i=0; i<REP_IMPULSE_LENGTH; i++)
	{	
		buff = double(REP_IMPULSE_Y0-rep_impulse_y[i]);
		buff>maxval? maxval=buff : 1;
		reponse[rep_impulse_x[i]-REP_IMPULSE_X0] = buff; 
	}

// normalisation à 1 :
	for (i=0; i<REP_IMPULSE_LENGTH; i++)
		reponse[rep_impulse_x[i]-REP_IMPULSE_X0] /= maxval;
	
}
