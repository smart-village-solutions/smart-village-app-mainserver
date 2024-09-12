# frozen_string_literal: true

class StaticContent::StructureService
  def initialize(static_content_id)
    @static_content = StaticContent.find(static_content_id)
    @static_contents_to_analyze = StaticContent.unscoped.where(name: @static_content.name)
  end

  def json
    hashes = @static_contents_to_analyze.map do |json|
      JSON.parse(json.content)
    rescue StandardError
      {}
    end
    combined_hash = hashes.reduce({}) do |accumulator, hash|
      deep_merge_hashes(accumulator, hash)
    end

    combined_hash = deep_sort_hash_by_key(combined_hash)
    combined_hash = replace_values_with_dummy_data(combined_hash)
    JSON.pretty_generate(combined_hash)
  end

  # Rekursive Funktion zum Sortieren eines Hashes nach Keys (auch für verschachtelte Hashes)
  def deep_sort_hash_by_key(hash)
    return hash unless hash.is_a?(Hash)

    sorted_hash = hash.sort.to_h
    sorted_hash.each do |key, value|
      if value.is_a?(Hash)
        sorted_hash[key] = deep_sort_hash_by_key(value)
      elsif value.is_a?(Array)
        sorted_hash[key] = value.map do |item|
          item.is_a?(Hash) ? deep_sort_hash_by_key(item) : item
        end
      end
    end
    sorted_hash
  end

  def deep_merge_hashes(hash1, hash2)
    return hash1 if hash2.empty? # Return the first hash if the second one is empty
    return hash2 if hash1.empty? # Return the second hash if the first one is empty
    return hash1 | hash2 if hash1.is_a?(Array) && hash2.is_a?(Array) # Union of arrays to avoid TypeError

    if hash1.is_a?(Hash) && hash2.is_a?(Hash)
      hash1.merge(hash2) do |_key, old_val, new_val|
        if old_val.is_a?(Hash) && new_val.is_a?(Hash)
          deep_merge_hashes(old_val, new_val) # Recursive merging for nested hashes
        elsif old_val.is_a?(Array) && new_val.is_a?(Array)
          old_val | new_val # Union of arrays to avoid TypeError
        else
          new_val # The newer value replaces the old one in case of conflicts
        end
      end
    else
      hash1
    end
  end

  # Funktion zum Ersetzen von finalen Werten durch Dummydaten
  def replace_values_with_dummy_data(hash)
    if hash.is_a?(Array)
      hash.map do |item|
        item.is_a?(Hash) ? replace_values_with_dummy_data(item) : "dummy_array_item"
      end
    end

    if hash.is_a?(Hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          replace_values_with_dummy_data(value) # Rekursiv weitergehen, wenn es ein Hash ist
        elsif value.is_a?(Array)
          hash[key] = value.map do |item|
            item.is_a?(Hash) ? replace_values_with_dummy_data(item) : "dummy_array_item"
          end
        else
          # Ersetze finale Werte mit Dummydaten basierend auf dem Typ
          hash[key] = case value
                      when String
                        "dummy_string"
                      when Numeric
                        0
                      when TrueClass, FalseClass
                        false
                      else
                        "dummy_value"
                      end
        end
      end
    end

    hash
  end
end
