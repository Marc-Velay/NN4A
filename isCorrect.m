    function answer = isCorrect(dist, labels);
      
      answer = 0;
      predictions = zeros(length(labels),1);
      for j = 1:length(labels)
         predictions(j) = sum(dist(:,2)==labels(j));
      end;
      [maxval, col] = max(predictions,[],1);
      answer = labels(1, col);
      
  
    end;