# frozen_string_literal: true

module Was
  module ThumbnailService
    module Picker
      class MementoPickerThresholdGrouping
        def self.choose_mementos(mementos_list)
          chosen_list = []

          return chosen_list if mementos_list.nil? || mementos_list.size.zero?

          right = 0
          left = 1
          chosen_list = [mementos_list[right][:id]]

          i = 1
          while i < mementos_list.length
            simhash_diff = simhash_hamming_distance(mementos_list, right, left)
            if simhash_diff >= threshold
              chosen_list.push(mementos_list[left][:id])
              right = left
            end
            left += 1
            i += 1
          end
          chosen_list
        end

        def self.simhash_hamming_distance(mementos_list, right, left)
          mementos_list[right][:simhash_value].hamming_distance_to(mementos_list[left][:simhash_value])
        end

        def self.threshold
          Settings.threshold || 0
        end
      end
    end
  end
end
