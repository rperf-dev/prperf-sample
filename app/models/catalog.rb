# A fixed, in-memory dataset for the demo — no database, no randomness, no time.
# Built once and memoized, so every request does identical work. That determinism
# is what makes prperf's allocation/GC counts stable to the unit, so even a small
# regression in a PR shows up clearly.
module Catalog
  CATEGORIES = %w[books toys tools games music].freeze

  def self.products
    @products ||= Array.new(500) do |i|
      {
        id: i,
        name: "Product #{i}",
        category: CATEGORIES[i % CATEGORIES.size],
        price_cents: 100 + (i * 37) % 9_000,
        stock: (i * 7) % 50
      }
    end
  end
end
