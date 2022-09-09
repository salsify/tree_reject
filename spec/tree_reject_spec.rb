# frozen_string_literal: true

describe TreeReject do
  it "has a version number" do
    expect(TreeReject::VERSION).not_to be nil
  end

  context "TreeReject.tree_reject" do

    shared_examples "ignored keys in hash were removed" do
      specify "hash as object" do
        actual = TreeReject.tree_reject(original, ignored)
        expect(actual).to eq expected
      end

      specify "hash extension" do
        actual = original.tree_reject(ignored)
        expect(actual).to eq expected
      end
    end

    shared_examples "ignored keys in Virtus-like models were removed" do
      let(:test_model_klass) do
        Class.new(Struct.new(:a, :h, :v)) do
          def initialize(**attributes)
            attributes.each do |key, value|
              send("#{key}=", value)
            end
          end

          alias_method :to_hash, :to_h
        end
      end

      specify do
        actual = TreeReject.tree_reject(test_model_klass.new(**original), ignored)
        expect(actual).to eq expected
      end
    end

    context "removes top level key" do
      let(:original) { { a: 1 } }
      let(:expected) { {} }
      let(:ignored) { :a }

      it_behaves_like "ignored keys in hash were removed"
      it_behaves_like "ignored keys in Virtus-like models were removed"
    end

    context "removed top level key with children" do
      let(:original) { { h: { b: 1 } } }
      let(:expected) { {} }
      let(:ignored) { :h }

      it_behaves_like "ignored keys in hash were removed"
      it_behaves_like "ignored keys in Virtus-like models were removed"
    end

    context "removed child key" do
      let(:original) { { h: { b: 1, c: 2 } } }
      let(:expected) { { h: { c: 2 } } }
      let(:ignored) { { h: :b } }

      it_behaves_like "ignored keys in hash were removed"
      it_behaves_like "ignored keys in Virtus-like models were removed"
    end

    context "non-existent top-level key ignored" do
      let(:original) { { a: 1 } }
      let(:expected) { { a: 1 } }
      let(:ignored) { :b }

      it_behaves_like "ignored keys in hash were removed"
      it_behaves_like "ignored keys in Virtus-like models were removed"
    end

    context "non-existent child key ignored" do
      let(:original) { { a: 1 } }
      let(:expected) { { a: 1 } }
      let(:ignored) { { b: :c } }

      it_behaves_like "ignored keys in hash were removed"
      it_behaves_like "ignored keys in Virtus-like models were removed"
    end

    context "sibling keys removed, array of hashes" do
      let(:original) { { h: { b: 1, c: 2, d: 3 } } }
      let(:expected) { { h: { d: 3 } } }
      let(:ignored) { [{ h: :b }, { h: :c }] }

      it_behaves_like "ignored keys in hash were removed"
      it_behaves_like "ignored keys in Virtus-like models were removed"
    end

    context "sibling keys removed, hash of arrays" do
      let(:original) { { h: { b: 1, c: 2, d: 3 } } }
      let(:expected) { { h: { d: 3 } } }
      let(:ignored) { { h: [:b, :c] } }

      it_behaves_like "ignored keys in hash were removed"
      it_behaves_like "ignored keys in Virtus-like models were removed"
    end


    context "removed Virtus object child key" do
      let(:original) { { v: { a: 1 } } }
      let(:expected) { {} }
      let(:ignored) { { v: :a } }

      it_behaves_like "ignored keys in Virtus-like models were removed"
    end
  end
end
