# Builds the catalog summary returned by GET /report. This is the code the demo
# benchmark measures: a PR that makes it allocate more shows up on the prperf
# Check Run as a higher `alloc` count (and trips the +5% threshold).
class ReportBuilder
  def initialize(products)
    @products = products
  end

  def summary
    {
      total_products: @products.size,
      categories: Catalog::CATEGORIES.sort.map { |category| category_summary(category) },
      top_value: top_value(5)
    }
  end

  private

  # Per-category rollup — now with an average price and a human-readable label
  # for each item, so clients don't have to format names themselves.
  def category_summary(category)
    items = @products.select { |p| p[:category] == category }
    {
      name: category,
      count: items.size,
      revenue_cents: items.sum { |p| p[:price_cents] * p[:stock] },
      in_stock: items.count { |p| p[:stock].positive? },
      avg_price_cents: items.sum { |p| p[:price_cents] } / items.size,
      items: items.map { |p| "#{p[:name]} — #{p[:category]}" }
    }
  end

  # The five products with the highest price * stock, in one pass.
  def top_value(limit)
    @products
      .max_by(limit) { |p| p[:price_cents] * p[:stock] }
      .map { |p| { id: p[:id], name: p[:name], value_cents: p[:price_cents] * p[:stock] } }
  end
end
