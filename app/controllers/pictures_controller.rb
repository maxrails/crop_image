class PicturesController < InheritedResources::Base

  before_filter :only=>:show do
    picture = Picture.find(params[:id])
    @sizes = picture.get_width_height
  end

  def save_resized
    if params[:imageSource].present?
      @picture = Picture.find(params[:imageSource].gsub('/uploads/picture/image/','').split('/')[0]) rescue nil
      if @picture
        if (params[:imageW].present? && params[:imageW].to_i != params[:viewPortW].to_i || params[:imageH].present? && params[:imageH].to_i != params[:viewPortH].to_i) && params[:imageRotate].to_i <= 0
          @picture.scale(params[:imageW].to_f,params[:imageX].to_f,params[:imageY].to_f)
        end
        if params[:imageRotate].present? && params[:imageRotate].to_i > 0 #rotate_translate
          @picture.rotate_translate(params[:imageRotate].to_i,params[:imageX].to_f,params[:imageY].to_f,params[:imageW].to_i != params[:viewPortW].to_i,params[:imageH].to_f)
        end
        if params[:imageRotate].to_i <= 0 && params[:imageW].to_i == params[:viewPortW].to_i && (params[:imageX].present? && params[:imageX].to_f!=0.0 || params[:imageY].present? && params[:imageY].to_f != 0.0) #shift image
          @picture.shift(params[:imageX].to_f,params[:imageY].to_f)
        end
        if params[:selectorX].present? && params[:selectorX].to_i > 0 || params[:selectorY].present? && params[:selectorY].to_i > 0 || params[:selectorW].present? && params[:selectorW].to_i < params[:viewPortW].to_i-2 || params[:selectorH].present? && params[:selectorH].to_i < params[:viewPortH].to_i-2 # corp image
          @picture.crop(params[:selectorX].to_i,params[:selectorY].to_i,params[:selectorW].to_i,params[:selectorH].to_i)
        end
        @picture.create_resized #Save as resized_image
      else
        redirect_to picture_path(@picture), :alert=>"Something goes wrong, please resize image again"
      end
    else
      redirect_to picture_path(@picture), :alert=>"Something goes wrong, please resize image again"
    end
  end
end
