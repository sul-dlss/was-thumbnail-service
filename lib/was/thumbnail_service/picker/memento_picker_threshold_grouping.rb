module Was
  module ThumbnailService
    module picker
      class MementoPickerThresholdGrouping
         @threshold = 0
  
        def self.choose_mementos mementos_list
          puts "Input memento list" 
          puts mementos_list
          chosen_list = []
          
          if mementos_list.nil? || mementos_list.length == 0 then
            return chosen_list
          end
          
          right = 0
          left = 1
          chosen_list = [mementos_list[right][:id]]
  
          i = 1
          while i < mementos_list.length do
            simhash_diff = self.simhash_hamming_distance(mementos_list, right, left)
            puts right, left, simhash_diff
            if  simhash_diff < @threshold then
              left = left + 1
            else
              chosen_list.push(mementos_list[left][:id])
              right = left
              left = left + 1
            end
            i = i+1
          end
            puts "Chosen memento list" 
          puts chosen_list
          return chosen_list
        end
        
        def self.simhash_hamming_distance(mementos_list, right, left)
          return mementos_list[right][:simhash_value].hamming_distance_to(mementos_list[left][:simhash_value])
        end
      end
    end
  end
end