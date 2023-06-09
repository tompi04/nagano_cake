class Public::AddressesController < ApplicationController

  before_action :authenticate_customer!
  before_action :is_matching_login_customer, only: [:edit, :update]

  def index
    @address = Address.new
    @addresses = Address.all
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      flash[:notice] = "配送先の登録が完了しました"
      redirect_to addresses_path
    else
      render :index
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    address = Address.find(params[:id])
    if address.update(address_params)
      flash[:notice] = "変更が完了しました"
      redirect_to addresses_path
    else
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to addresses_path
  end


  private

  def address_params
  params.require(:address).permit(:name, :postal_code, :address, :customer_id)
  end

  def is_matching_login_customer
    customer = Address.find(params[:id]).customer_id
    unless customer ==current_customer.id
      redirect_to addresses_path
    end
  end

end