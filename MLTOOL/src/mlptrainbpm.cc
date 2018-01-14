
/*
  
  signet/src/neurons/mlptrainbpm.cc

   BackPropagation with Momentum

               0.0


  B. Gas
  UPMC, LIS/PC

  création : mai 1998
  derniere révision : -

*/

#define MLPLEARNBPM_CC

#include <iostream.h>
#include <signet_error.h>
#include <signet.h>
#include <neurons.h>




int mlptrainbpm(struct_mlp2 *w, double *ex, char *excl, int nb_ex, 
	double *L, int nb_iter, double lr, double beta, double moment)
{
  msg_error(!w,"mlptrainbpm()",__LINE__,"pointeur null : 1er argument 'struct_mlp*' non alloué");
  msg_error(!ex || !excl || !L,"mlptrainbpm()",__LINE__,
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
	"mlptrainbp()",__LINE__);
 
  double max_error2=4*nb_out*nb_ex;
  lr /= (nb_ex*nb_out);


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

    L[it] = 0;    

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

// predictive cell output :
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



