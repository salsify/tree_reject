# frozen_string_literal: true

require 'tree_reject/version'

module TreeReject
  extend self

  module TreeRejectHash
    def tree_reject(ignorned_keys)
      TreeReject.tree_reject(self, ignorned_keys)
    end
  end

  # returns a new map with the ignored keys removed
  # ignored_keys must be an array of IKItems
  # IKItem is the type <Symbol | Array<IkItem> | Hash<Symbol, IKItem>>
  # keys are only removed if their path in the trees match
  def tree_reject(map, ignored_keys)
    ignored_leaves = extract_leaves(ignored_keys)
    ignored_subtrees = extract_subtrees(ignored_keys, ignored_leaves)

    map.to_h.each_with_object({}) do |(k, v), cleaned|
      if ignored_leaves.include?(k)
        next
      elsif v.is_a?(Hash) || v.respond_to?(:attributes)
        cleaned_v = tree_reject(v.to_h, ignored_subtrees[k])
        cleaned[k] = cleaned_v unless cleaned_v == {}
      elsif !v.nil?
        cleaned[k] = v
      end
    end
  end

  private

  # extract the top level leaves from the ignored_keys tree structure
  def extract_leaves(ignored_keys)
    [ignored_keys].flatten.reject { |ignored_key| ignored_key.is_a?(Hash) }
  end

  # extract the top level subtrees from the ignored_keys tree structure, skipping ones included ignored_leaves
  def extract_subtrees(ignored_keys, ignored_leaves)
    [ignored_keys].flatten.select { |ignored_key| ignored_key.is_a?(Hash) }.inject({}) do |h, ignored_subtree|
      ignored_subtree.each_pair do |k, v|
        next if ignored_leaves.include?(k)

        if h.key?(k)
          h[k] << v
        else
          h[k] = [v]
        end
      end
      h
    end
  end
end

Hash.include(TreeReject::TreeRejectHash)
