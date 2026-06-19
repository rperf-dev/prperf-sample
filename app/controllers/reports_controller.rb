class ReportsController < ApplicationController
  # GET /report — a JSON summary of the in-memory catalog. The demo benchmark
  # (bench/request.rb) drives this endpoint under rperf in CI.
  def show
    render json: ReportBuilder.new(Catalog.products).summary
  end
end
