
/*
  
  signet/src/neurons/mlptrainbpma.cc

   Adaptive BackPropagation with Momentum

               0.0


  B. Gas
  UPMC, LIS/PC

  création : juin 1998
  derniere révision : -

*/

#define MLPLEARNBPMA_CC

#include <iostream.h>
#include <signet_error.h>
#include <signet.h>
#include <neurons.h>


// apprentissage avec cross-validation

int mlptrainbpma(struct_mlp2 *w, double *ex, char *excl, int nb_ex,
	double *L, int nb_iter, double lr0, double beta, double moment,
	double *LR, double dec, double inc, double delta,
	double *val, char *valcl, int nb_val, double *LV, double *RECOVAL, int nb_iter_val)
{
  msg_error(!w,"mlptrainbpma()",__LINE__,"pointeur null : 1er argument 'struct_mlp*' non alloué");
  msg_error(!ex || !excl || !L,"mlptrainbpma()",__LINE__,
	"pointeur null : un au moins des tableaux 'ex', 'L' ou 'excl' non alloué.");
  msg_error(!val || !valcl || !LV || !RECOVAL,"mlptrainbpma()",__LINE__,
	"pointeur null : un au moins des tableaux 'val', 'LV', 'RECOVAL' ou 'valcl' non alloué.");

  int nb_in  = w->input_size;
  int nb_hcl = w->hl_size;
  int nb_out = w->output_size;

  double *W1 = w->w1;
  double *W2 = w->w2;
  double *B1 = w->b1;
  double *B2 = w->b2;

  double *dW1 	= new double [nb_in*nb_hcl];
  double *dB1 	= new double [nb_hcl];
  double *mdW1 	= new double [nb_in*nb_hcl];
  double *mdB1 	= new double [nb_hcl];
  double *Delta1= new double [nb_hcl];
  double *V1  	= new double [nb_hcl];
  double *S1  	= new double [nb_hcl];
  double *dW2 	= new double [nb_hcl*nb_out];
  double *dB2 	= new double [nb_out];
  double *mdW2 	= new double [nb_hcl*nb_out];
  double *mdB2 	= new double [nb_out];
  double *Delta2= new double [nb_out];
  double *V2 	= new double [nb_out];
  double *S2 	= new double [nb_out];
  double *E2 	= new double [nb_out];

  sys_error(!dW1 || !dB1 || !mdW1 || !mdB1 || !Delta1 || !V1 || !S1 ||
	!dW2 || !dB2 || !mdW2 || !mdB2 || !Delta2 || !V2 || !S2 || !E2,
	"mlptrainbpma()",__LINE__);

// normalizations :

  double max_error2=4*nb_out*nb_ex;
  double lr = lr0/(nb_ex*nb_out);
  delta = delta<0? -delta/(nb_ex*nb_out) : delta/(nb_ex*nb_out);
  dec = dec/(nb_ex*nb_out);
  inc = inc/(nb_ex*nb_out);

// cross-validation initializations:

  nb_iter_val>nb_iter? nb_iter_val=nb_iter : 1;
  warning(nb_iter_val>nb_iter,"mlptrainbpma()",__LINE__,
		"le nombre d'itérations de cross-validation dépasse celui d'apprentissage! [réajusté].");
  int freqval = nb_iter/nb_iter_val;
  int itval = 0;

// first initialization weights variation vectors :

  for(double *ptr=dW1+nb_in*nb_hcl-1; ptr>=dW1; *ptr--=0);
  for(double *ptr=dB1+nb_hcl-1; ptr>=dB1; *ptr--=0);
  for(double *ptr=dW2+nb_hcl*nb_out-1; ptr>=dW2; *ptr--=0);
  for(double *ptr=dB2+nb_out-1; ptr>=dB2; *ptr--=0);

  int it;
  for(it=0; it<nb_iter; it++)
  {

// cross-validation phase : -------------------------------------------------------
		if (it%freqval==0)
		{
			LV[itval] = 0;
			RECOVAL[itval] = 0;

	// first layer cells outputs :
			double *offset=val;
	    for(int nex=0; nex<nb_val; nex++)
  	  {
	      for(int hcell=0; hcell<nb_hcl; hcell++)
  	    {
    	    V1[hcell] = 0;
      	  for(int i=0; i<nb_in; i++)
        	  V1[hcell] += *(offset+i)*W1[hcell*nb_in+i];
					V1[hcell] += B1[hcell];
  	      S1[hcell] = sigmo(V1[hcell],beta);
    	  }

	// output layer cells output :
      	for(int ocell=0; ocell<nb_out; ocell++)
	      {
  	      V2[ocell] = 0;
    	    for(int i=0; i<nb_hcl; i++)
      	    V2[ocell] += S1[i]*W2[ocell*nb_hcl+i];
					V2[ocell] += B2[ocell];
  	      S2[ocell] = sigmo(V2[ocell],beta);
    	    E2[ocell] = double(valcl[nex*nb_out+ocell]) - S2[ocell];	// output error	

      	  LV[itval] += pow2(E2[ocell]);			// quadratic error					
	      }

	// score :
	// neurone gagnant :
		    double max = S2[0];
		    int indmax = 0;
    		for(int ocell=1; ocell<nb_out; ocell++)
	      if (max < S2[ocell])
  	    {
    	    max=S2[ocell];
      	  indmax = ocell;
	      }

	// sortie désirée gagnante :
  		  double maxd = double(valcl[nex*nb_out]);
		    int indmaxd = 0;
    		for(int ocell=1; ocell<nb_out; ocell++)
	      if (maxd < double(valcl[nex*nb_out+ocell]))
  	    {
    	    maxd=double(valcl[nex*nb_out+ocell]);
      	  indmaxd = ocell;
	      }

	// score :
  		  indmax==indmaxd? RECOVAL[itval]++ : 1;

  // next example :
				offset += nb_in;
    	}

    	LV[itval] /= max_error2;
			itval++;
		}

// end of cross-validation phase ---------------------------------------------------

// last modifications memorization :

    for(double *ptr=dW1+nb_in*nb_hcl-1, *ptrm=mdW1+nb_in*nb_hcl-1; ptr>=dW1;
			*ptrm--=*ptr, *ptr--=0);
    for(double *ptr=dB1+nb_hcl-1, *ptrm=mdB1+nb_hcl-1; ptr>=dB1;
			*ptrm--=*ptr, *ptr--=0);
    for(double *ptr=dW2+nb_hcl*nb_out-1, *ptrm=mdW2+nb_hcl*nb_out-1; ptr>=dW2;
			*ptrm--=*ptr, *ptr--=0);
    for(double *ptr=dB2+nb_out-1, *ptrm=mdB2+nb_out-1; ptr>=dB2;
			*ptrm--=*ptr, *ptr--=0);

// initial quadratic error = 0 :

    L[it]  = 0;
    LR[it] = lr;

    double *offset=ex;
    for(int nex=0; nex<nb_ex; nex++)
    {
// propagation phase :
// first layer cells outputs :
      for(int hcell=0; hcell<nb_hcl; hcell++)
      {
        V1[hcell] = 0;
        for(int i=0; i<nb_in; i++)
          V1[hcell] += *(offset+i)*W1[hcell*nb_in+i];
				V1[hcell] += B1[hcell];
        S1[hcell] = sigmo(V1[hcell],beta);
      }

// output layer cells output :
      for(int ocell=0; ocell<nb_out; ocell++)
      {
        V2[ocell] = 0;
        for(int i=0; i<nb_hcl; i++)
          V2[ocell] += S1[i]*W2[ocell*nb_hcl+i];
				V2[ocell] += B2[ocell];
        S2[ocell] = sigmo(V2[ocell],beta);
        E2[ocell] = double(excl[nex*nb_out+ocell]) - S2[ocell];	// output error	

        L[it] += pow2(E2[ocell]);			// quadratic error
				Delta2[ocell] = -2*E2[ocell]*sigmop(V2[ocell],beta);
      }

// backpropagation phase :
// 2nde layer weights modification :
      for(int ocell=0; ocell<nb_out; ocell++)
      {
        for (int hcell=0; hcell<nb_hcl; hcell++)
          dW2[ocell*nb_hcl+hcell] += Delta2[ocell]*S1[hcell];

        dB2[ocell] += Delta2[ocell];
      }

// error back propagation :
      for (int hcell=0; hcell<nb_hcl; hcell++)
      {
				Delta1[hcell] = 0;
				for (int ocell=0; ocell<nb_out; ocell++)	
          Delta1[hcell] += W2[ocell*nb_hcl+hcell]*Delta2[ocell];
				Delta1[hcell] *= sigmop(V1[hcell],beta);

        for (int i=0; i<nb_in; i++)
          dW1[hcell*nb_in+i] += *(offset+i)*Delta1[hcell];
        dB1[hcell] += Delta1[hcell];
      }

// next example :
      offset += nb_in;
    }

    L[it] /= max_error2;

// learning rate adaptation :

    if (it>0)
      if (L[it]-L[it-1]>0)
        lr -= dec;
      else if (L[it]-L[it-1]<-delta)
        lr += inc;

// weights adaptation with momentum :

    for(double *ptrDW=dW1+nb_in*nb_hcl-1, *ptrW=W1+nb_in*nb_hcl-1,
			*ptrmDW=mdW1+nb_in*nb_hcl-1; ptrDW>=dW1;
			*ptrW-- += -lr*((*ptrDW--) + moment*(*ptrmDW--)));

    for(double *ptrDW=dW2+nb_hcl*nb_out-1, *ptrW=W2+nb_hcl*nb_out-1,
			*ptrmDW=mdW2+nb_hcl*nb_out-1; ptrDW>=dW2;
			*ptrW-- += -lr*((*ptrDW--) + moment*(*ptrmDW--)));

    for(double *ptrDB=dB1+nb_hcl-1, *ptrB=B1+nb_hcl-1,
			*ptrmDB=mdB1+nb_hcl-1; ptrDB>=dB1;
			*ptrB-- += -lr*((*ptrDB--) + moment*(*ptrmDB--)));

    for(double *ptrDB=dB2+nb_out-1, *ptrB=B2+nb_out-1,
			*ptrmDB=mdB2+nb_out-1; ptrDB>=dB2;
			*ptrB-- += -lr*((*ptrDB--) + moment*(*ptrmDB--)));

  }


  delete [] dW1;
  delete [] dB1;
  delete [] Delta1;
  delete [] dW2;
  delete [] dB2;
  delete [] Delta2;
  delete [] V1;
  delete [] S1;
  delete [] V2;
  delete [] S2;
  delete [] E2;
  delete [] mdW1;
  delete [] mdB1;
  delete [] mdW2;
  delete [] mdB2;

  return it;
}





// apprentissage sans cross_validation


int mlptrainbpma(struct_mlp2 *w, double *ex, char *excl, int nb_ex, 
	double *L, int nb_iter, double lr0, double beta, double moment,
	double *LR, double dec, double inc, double delta)
{
  msg_error(!w,"mlptrainbpma()",__LINE__,"pointeur null : 1er argument 'struct_mlp*' non alloué");
  msg_error(!ex || !excl || !L,"mlptrainbpma()",__LINE__,
	"pointeur null : un au moins des tableaux 'ex', 'L' ou 'ex_size' non alloué.");

  int nb_in  = w->input_size;
  int nb_hcl = w->hl_size;
  int nb_out = w->output_size;

  double *W1 = w->w1;
  double *W2 = w->w2;
  double *B1 = w->b1;
  double *B2 = w->b2;

  double *dW1 	= new double [nb_in*nb_hcl];
  double *dB1 	= new double [nb_hcl];
  double *mdW1 	= new double [nb_in*nb_hcl];
  double *mdB1 	= new double [nb_hcl];
  double *Delta1= new double [nb_hcl];
  double *V1  	= new double [nb_hcl];
  double *S1  	= new double [nb_hcl];
  double *dW2 	= new double [nb_hcl*nb_out];
  double *dB2 	= new double [nb_out];
  double *mdW2 	= new double [nb_hcl*nb_out];
  double *mdB2 	= new double [nb_out];
  double *Delta2= new double [nb_out];
  double *V2 	= new double [nb_out];
  double *S2 	= new double [nb_out];
  double *E2 	= new double [nb_out];

  sys_error(!dW1 || !dB1 || !mdW1 || !mdB1 || !Delta1 || !V1 || !S1 || 
	!dW2 || !dB2 || !mdW2 || !mdB2 || !Delta2 || !V2 || !S2 || !E2,
	"mlptrainbpma()",__LINE__);
 
// normalizations :

  double max_error2=4*nb_out*nb_ex;
  double lr = lr0/(nb_ex*nb_out);
  delta = delta<0? -delta/(nb_ex*nb_out) : delta/(nb_ex*nb_out);
  dec = dec/(nb_ex*nb_out);
  inc = inc/(nb_ex*nb_out);

// first initialization weights variation vectors :

  for(double *ptr=dW1+nb_in*nb_hcl-1; ptr>=dW1; *ptr--=0);
  for(double *ptr=dB1+nb_hcl-1; ptr>=dB1; *ptr--=0);
  for(double *ptr=dW2+nb_hcl*nb_out-1; ptr>=dW2; *ptr--=0);
  for(double *ptr=dB2+nb_out-1; ptr>=dB2; *ptr--=0);

  int it;
  for(it=0; it<nb_iter; it++)
  {

// last modifications memorization :

    for(double *ptr=dW1+nb_in*nb_hcl-1, *ptrm=mdW1+nb_in*nb_hcl-1; ptr>=dW1; 
			*ptrm--=*ptr, *ptr--=0);
    for(double *ptr=dB1+nb_hcl-1, *ptrm=mdB1+nb_hcl-1; ptr>=dB1; 
			*ptrm--=*ptr, *ptr--=0);
    for(double *ptr=dW2+nb_hcl*nb_out-1, *ptrm=mdW2+nb_hcl*nb_out-1; ptr>=dW2; 
			*ptrm--=*ptr, *ptr--=0);
    for(double *ptr=dB2+nb_out-1, *ptrm=mdB2+nb_out-1; ptr>=dB2; 
			*ptrm--=*ptr, *ptr--=0);

// initial quadratic error = 0 :

    L[it]  = 0;    
    LR[it] = lr;

// training phase :

    double *offset=ex;    
    for(int nex=0; nex<nb_ex; nex++)
    {       
      
// first layer cells outputs :       
      for(int hcell=0; hcell<nb_hcl; hcell++)
      {
        V1[hcell] = 0;
        for(int i=0; i<nb_in; i++)          
          V1[hcell] += *(offset+i)*W1[hcell*nb_in+i];
				V1[hcell] += B1[hcell];
        S1[hcell] = sigmo(V1[hcell],beta);
      }

// output layer cells output :
      for(int ocell=0; ocell<nb_out; ocell++)
      {
        V2[ocell] = 0;
        for(int i=0; i<nb_hcl; i++)          
          V2[ocell] += S1[i]*W2[ocell*nb_hcl+i];
				V2[ocell] += B2[ocell];
        S2[ocell] = sigmo(V2[ocell],beta);
        E2[ocell] = double(excl[nex*nb_out+ocell]) - S2[ocell];	// output error	

        L[it] += pow2(E2[ocell]);			// quadratic error
				Delta2[ocell] = -2*E2[ocell]*sigmop(V2[ocell],beta);
      }
// 2nde layer weights modification :              
      for(int ocell=0; ocell<nb_out; ocell++)
      {
        for (int hcell=0; hcell<nb_hcl; hcell++)        
          dW2[ocell*nb_hcl+hcell] += Delta2[ocell]*S1[hcell];

        dB2[ocell] += Delta2[ocell];      
      }

// error back propagation :
      for (int hcell=0; hcell<nb_hcl; hcell++)
      {
				Delta1[hcell] = 0;
				for (int ocell=0; ocell<nb_out; ocell++)	
          Delta1[hcell] += W2[ocell*nb_hcl+hcell]*Delta2[ocell];
				Delta1[hcell] *= sigmop(V1[hcell],beta);
          
        for (int i=0; i<nb_in; i++)
          dW1[hcell*nb_in+i] += *(offset+i)*Delta1[hcell];
        dB1[hcell] += Delta1[hcell];
      }

// next example :      
      offset += nb_in;       
    }

    L[it] /= max_error2; 

// learning rate adaptation :

    if (it>0)
      if (L[it]-L[it-1]>0)
        lr -= dec;
      else if (L[it]-L[it-1]<-delta)
        lr += inc;

// weights adaptation with momentum :

    for(double *ptrDW=dW1+nb_in*nb_hcl-1, *ptrW=W1+nb_in*nb_hcl-1, 
			*ptrmDW=mdW1+nb_in*nb_hcl-1; ptrDW>=dW1;
			*ptrW-- += -lr*((*ptrDW--) + moment*(*ptrmDW--)));

    for(double *ptrDW=dW2+nb_hcl*nb_out-1, *ptrW=W2+nb_hcl*nb_out-1,
			*ptrmDW=mdW2+nb_hcl*nb_out-1; ptrDW>=dW2;
			*ptrW-- += -lr*((*ptrDW--) + moment*(*ptrmDW--)));

    for(double *ptrDB=dB1+nb_hcl-1, *ptrB=B1+nb_hcl-1,
			*ptrmDB=mdB1+nb_hcl-1; ptrDB>=dB1;
			*ptrB-- += -lr*((*ptrDB--) + moment*(*ptrmDB--)));

    for(double *ptrDB=dB2+nb_out-1, *ptrB=B2+nb_out-1, 
			*ptrmDB=mdB2+nb_out-1; ptrDB>=dB2;
			*ptrB-- += -lr*((*ptrDB--) + moment*(*ptrmDB--)));

  }           


  delete [] dW1;
  delete [] dB1;
  delete [] Delta1;
  delete [] dW2;
  delete [] dB2;
  delete [] Delta2;
  delete [] V1;
  delete [] S1;
  delete [] V2;
  delete [] S2;
  delete [] E2;
  delete [] mdW1;
  delete [] mdB1;
  delete [] mdW2; 
  delete [] mdB2;

  return it;
}



