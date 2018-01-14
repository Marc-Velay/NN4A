    function dist = euclideanDistance(data_point, data_app, label_app, k);
      
      nb_examples = length(data_app);
      dist = zeros(nb_examples, 1+size(label_app,1));
      
      for i = 1:nb_examples
        dist(i,1) = sqrt(sum((data_point-data_app(:,i)).^2));      
      end;
  
      for i = 1:nb_examples
        dist(i,2) = label_app(1,i);     
      end;
      
      dist = sortrows(dist, 1);
      dist = dist(2:1+k, :);
  
    end;