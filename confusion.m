  function conf_mat = confusion(truth, preds, labels);
    
    nb_labels = length(labels);
    conf_mat = zeros(nb_labels, nb_labels);
    
    for i = 1:length(truth)
    
      conf_mat(labels(truth(i)), labels(preds(i))) = conf_mat(labels(truth(i)), labels(preds(i)))+1;
    
    end;
    
  end;