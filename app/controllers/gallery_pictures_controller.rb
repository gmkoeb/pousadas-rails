class GalleryPicturesController < ApplicationController
  before_action :authenticate_admin!, :admin_has_inn?

  def new
    @inn = Inn.friendly.find(params[:inn_id]) if params[:inn_id]
    @room = Room.friendly.find(params[:room_id]) if params[:room_id]
    @gallery_picture = GalleryPicture.new
    if @inn
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @inn
    elsif @room
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @room.inn
    end
  end

  def create
    return if params[:gallery_picture].nil? 

    picture_params = params.require(:gallery_picture).permit(:picture)
    if params[:inn_id]
      @inn = Inn.friendly.find(params[:inn_id])
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @inn

      @gallery_picture = @inn.gallery_pictures.build(picture_params)
      if @gallery_picture.save
        return redirect_to inn_path(@inn), notice: 'Imagem adicionada com sucesso'
      else
        flash.now[:alert] = 'Não foi possível adicionar imagem.'
        render 'new'
      end
    else
      @room = Room.friendly.find(params[:room_id])
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @room.inn

      @gallery_picture = @room.gallery_pictures.build(picture_params)
      if @gallery_picture.save
        return redirect_to room_path(@room), notice: 'Imagem adicionada com sucesso'
      else
        flash.now[:alert] = 'Não foi possível adicionar imagem.'
        render 'new'
      end
    end
  end

  def destroy
    @gallery_picture = GalleryPicture.find(params[:id])
    if @gallery_picture.inn_id
      inn_id = @gallery_picture.inn_id
      inn = Inn.find(inn_id)
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @inn

      @gallery_picture.delete
      return redirect_to inn_path(inn), notice: 'Imagem removida com sucesso'
    else
      room_id = @gallery_picture.room_id
      room = Room.find(room_id)
      return redirect_to root_path, alert: 'Você não pode realizar essa ação.' if current_user.inn != @room.inn
      
      @gallery_picture.delete
      return redirect_to room_path(room), notice: 'Imagem removida com sucesso'
    end
  end
  
end