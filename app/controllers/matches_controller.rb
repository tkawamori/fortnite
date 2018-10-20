class MatchesController < ApplicationController
  before_action :authenticate_user!, except: :show
  def index
    @matches = Match.all.includes(:user).where(user_id: current_user.id) #user_idがcurrent_user.idのMatchを取得
    @entries = Entry.all.includes(:user,:match) #Entryを取得
  end

  def new
    @match = Match.new
  end

  def create
    @match = Match.new(match_params)
    image = Magick::ImageList.new('./public/base_image.png')
      draw = Magick::Draw.new
      title = cut_text(@match.title)
      draw.annotate(image, 0, 0, 0, -120, title) do
        self.font = 'app/assets/NotoSansJP-Bold.otf' #日本語対応可能なフォントにする
        self.fill = '#fff' #フォントの塗りつぶし色
        self.gravity = Magick::CenterGravity #描画基準位置(中央)
        self.font_weight = Magick::BoldWeight #フォントの太さ
        self.stroke = 'transparent' #フォント縁取り色(透過)
        self.pointsize = 48 #フォントサイズ（48pt）
      end
    image_path = image.write(uniq_file_name).filename #書き出したファイルのファイル名前
    image_url = cut_path(image_path) #不要なパスをcutする
    @match.image_url = image_url #@matchのimage_urlにcutしたimage_urlを代入
    if @match.save
        flash[:notice] = "投稿が保存されました"
        redirect_to @match
    else
        flash[:alert] = "投稿に失敗しました"
    end
  end

  def show
    @match = Match.find(params[:id])
    @entries = Entry.where(match_id:@match)
  end

  private

  def cut_path(url)
    url.sub(/\.\/public\//, "")
  end

  def uniq_file_name
    "./public/#{SecureRandom.hex}.png"
  end

  def cut_text(text)
      text.scan(/.{1,15}/).join("\n")
  end

  def match_params
	params.require(:match).permit(:title, :content).merge(user_id: current_user.id)
  end

end
