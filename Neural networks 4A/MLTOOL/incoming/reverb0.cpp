/*

	reverb.cpp

	Effet de r�verb�ration appliqu� � un signal audio mono
    (utiliser reverb2 pour un signal st�r�o).
	R�ponse impulsionnelle tir�e du cours Multim�dia de 
	Sylvain Machel.
	
	Bruno Gas - LISIF/PARC UPMC <gas@ccr.jussieu.fr>
	Cr�ation : 8 octobre 2001
	Version 1.0
	Dernieres r�visions :	
*/


// ----- en-t�tes C,C++

#include <iostream.h>


// ----- en-t�tes toolbox RdF et SpecRdF

int reverb(double *rvsignal, const double *signal, int size, int delay, double gain);



// ----- usage 

#define usage "usage : RVSignal = reverb(Signal, Delay, Gain)"



// ----- fonction mex

#include "mex.h"

void mexFunction(int nargout, mxArray *argout[], int nargin, const mxArray *argin[])
{
	if (nargin!=3)
		mexErrMsgTxt(usage);
	
	const mxArray *signal	= argin[0];     // signal original
	const mxArray *delay	= argin[1];		// temps de r�verb�ration
	const mxArray *gain		= argin[2];     // gain r�verb�ration

// dimensions :
	int siglength	= mxGetM(signal);		// nombre d'�chantillons du signal
	int channels	= mxGetN(ex);			// nombre de voies 1=mono, 2=st�r�o)
	
// valeurs de retour :
	mxArray *RVsignal = mxCreateDoubleMatrix(channels, siglength, mxREAL); 

// R�ponse impulsionnelle :

	mxArray *Nwcodes = mxCreateDoubleMatrix(code_size, class_nbr, mxREAL); 
	memcpy((unsigned char*)mxGetPr(Nwcodes),(unsigned char*)mxGetPr(wcodes),
		code_size*class_nbr*mxGetElementSize(wcodes));

	mxArray *Nwparams = mxCreateDoubleMatrix(hcell_nbr, win_size, mxREAL); 
	memcpy((unsigned char*)mxGetPr(Nwparams),(unsigned char*)mxGetPr(wparams),
		hcell_nbr*win_size*mxGetElementSize(wparams));

	mxArray *Nbparams = mxCreateDoubleMatrix(hcell_nbr, 1, mxREAL); 
	memcpy((unsigned char*)mxGetPr(Nbparams),(unsigned char*)mxGetPr(bparams),
		hcell_nbr*mxGetElementSize(bparams));


// pointeurs data :

	const double *Psignal	= mxGetPr(signal);
	double *PRVsignal		= mxGetPr(RVsignal);

// controle donn�es : 

// filtrage du signal :

	reverb(PRVsignal, Psignal, delay, gain);
	
	argout[0] = RVsignal;
}


int reverb(double *rvsignal, const double *signal, int size, int delay, double gain)
{
}

