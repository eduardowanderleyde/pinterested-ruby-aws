class PinsController < ApplicationController
  before_action :set_pin, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :correct_user, only: %i[edit update destroy]

  def index
    @pins = Pin.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 6)
    @pins_with_expiring_urls = @pins.map do |pin|
      {
        pin: pin,
        expiring_url: pin.image.present? ? pin.image.expiring_url(3600) : nil
      }
    end
  end

  def show
    @pin = Pin.find(params[:id])
    @image_url = @pin.image.expiring_url(3600) if @pin.image.present? # URL válida por 1 hora
  end

  def new
    @pin = current_user.pins.build
  end

  def edit
  end

  def create
    @pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to @pin, notice: 'Pin was successfully created.'
    else
      render :new
    end
  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: 'Pin was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @pin.destroy
    redirect_to pins_url, notice: 'Pin was successfully destroyed.'
  end

  private

  def set_pin
    @pin = Pin.find(params[:id])
  end

  def pin_params
    params.require(:pin).permit(:description, :image)
  end

  def correct_user
    @pin = current_user.pins.find_by(id: params[:id])
    redirect_to pins_path, notice: 'Not authorized to edit this pin' if @pin.nil?
  end
end
