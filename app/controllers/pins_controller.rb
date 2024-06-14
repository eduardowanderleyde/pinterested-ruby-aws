# app/controllers/pins_controller.rb
class PinsController < ApplicationController
  before_action :set_pin, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :correct_user, only: %i[edit update destroy]

  def index
    @pins = Pin.all
  end

  def show
    puts "Debug: @pin.image.path => #{@pin.image.path}"
    puts "Debug: @pin.image.url(:original) => #{@pin.image.url(:original)}"
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
