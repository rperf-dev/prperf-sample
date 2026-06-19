# Builds the catalog summary returned by GET /report. This is the code the demo
# benchmark measures: a PR that makes it allocate more shows up on the prperf
# Check Run as a higher `alloc` count (and trips the +5% threshold).
class ReportBuilder
  def initialize(products)
    @products = products
  end

  def summary
    by_category = Hash.new { |h, k| h[k] = { count: 0, revenue_cents: 0, in_stock: 0 } }

    @products.each do |p|
      agg = by_category[p[:category]]
      agg[:count] += 1
      agg[:revenue_cents] += p[:price_cents] * p[:stock]
      agg[:in_stock] += 1 if p[:stock].positive?
    end

    {
      total_products: @products.size,
      categories: by_category.sort.map { |name, agg| { name: name, **agg } },
      top_value: top_value(5)
    }
  end

  private

  # The five products with the highest price * stock, in one pass.
  def top_value(limit)
    @products
      .max_by(limit) { |p| p[:price_cents] * p[:stock] }
      .map { |p| { id: p[:id], name: p[:name], value_cents: p[:price_cents] * p[:stock] } }
  end
end
