class PortfoliosController < ApplicationController
  before_action :set_portfolio_item, only: [:show, :edit, :update, :destroy]
  # layout 'portfolio'
  access all: [:show, :index], user: {except: [:destroy, :new, :create, :update, :edit, :sort]}, site_admin: :all

  def index
    @portfolio_items = Portfolio.by_position
  end

  def sort
    params[:order].each do |key, value|
      Portfolio.find(value[:id]).update(position: value[:position])
    end

    render nothing: true
  end

  def new
    @portfolio = Portfolio.new
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)

    respond_to do |format|
      if @portfolio.save
        format.html { redirect_to portfolios_path, notice: 'Portfolio was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @portfolio.update(portfolio_params)
      redirect_to portfolio_show_path(@portfolio), notice: 'Portfolio was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @portfolio.destroy
    redirect_to portfolios_url, notice: 'Portfolio was successfully deleted.'
  end

  private

  def set_portfolio_item
    @portfolio = Portfolio.find(params[:id])
  end

  def portfolio_params
    params.require(:portfolio).permit(:title,
                                      :subtitle,
                                      :body,
                                      :main_image,
                                      :thumbnail,
                                      technologies_attributes: [:id, :name, :_destroy])
  end

end
