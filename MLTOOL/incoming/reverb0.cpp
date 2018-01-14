/*

	reverb.cpp

	Effet de réverbération appliqué à un signal audio mono
    (utiliser reverb2 pour un signal stéréo).
	Réponse impulsionnelle tirée du cours Multimédia de 
	Sylvain Machel.
	
	Bruno Gas - LISIF/PARC UPMC <gas@ccr.jussieu.fr>
	Création : 8 octobre 2001
	Version 1.0
	Dernieres révisions :	
*/


// ----- en-têtes C,C++

#include <iostream.h>


// ----- en-têtes toolbox RdF et SpecRdF

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
	const mxArray *delay	= argin[1];		// temps de réverbération
	const mxArray *gain		= argin[2];     // gain réverbération

// dimensions :
	int siglength	= mxGetM(signal);		// nombre d'échantillons du signal
	int channels	= mxGetN(ex);			// nombre de voies 1=mono, 2=stéréo)
	
// valeurs de retour :
	mxArray *RVsignal = mxCreateDoubleMatrix(channels, siglength, mxREAL); 

// Réponse impulsionnelle :

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

// controle données : 

// filtrage du signal :

	reverb(PRVsignal, Psignal, delay, gain);
	
	argout[0] = RVsignal;
}


int reverb(double *rvsignal, const double *signal, int size, int delay, double gain)
{
}

