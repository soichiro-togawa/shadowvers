class UsersController < ApplicationController
  
def index
  @user = User.new
end

def new
  @user = User.find_by(id: params[:id])
end
def show
  @user = User.find_by(id: params[:id])
end


    
def update
  @user = User.find_by(id: params[:id])
  @user.user_name = params[:user_name]

  
  # 画像を保存する処理を追加してください
    if params[:image]
    @user.image = "#{@user.id}.jpg"
    image = params[:image]
    File.binwrite("public/user_images/#{@user.image}",image.read)
    end
  
  # 保存後メソッド
  if @user.save && params[:image]
    
      # 記述個数
        if rand(1..7)==1
          @bun=1
          mana=rand(1..10)
        elsif rand(1..7)>=5
          @bun=3
          mana=rand(3..10)
        else
          @bun=2
          mana=rand(2..10)
        end
        
        # 乱数
        @levelmax=rand(mana..mana+1) 
        @mana=mana.to_s
        attack=rand(0..mana+2)
        if attack > 10
          attack=10
        end
        @attack=attack.to_s
        if attack > mana
          health=rand(1..mana)
        else
          health=rand(1..mana+2)
        end
        if health > 10
          health=10
        end
        
        @health=health.to_s
        leader=rand(1..8)
        @leader=leader.to_s
        
        
          # 検証用
            # @leader=7
            # @bun=1
            # @health=1.to_s
            # mana=10
            # @mana=10.to_s
            # @levelmax=6
        
        # レベル及びラインメソッド
          if @bun==1
             @level1=@levelmax
             @dog1=Dog.where(classid: [@leader,9],level: @level1)
             
            # 検証用
            # @dog1=Dog.where(idd: 722)
             
             @dog1=@dog1.offset( rand(@dog1.count) ).first
             
          elsif @bun==2
            @level1=rand(1..@levelmax-1)
            @level2=@levelmax-@level1
            @dog1=Dog.where(classid: [@leader,9],level: @level1, priority: [nil,1]).where("manamin < ?", mana).where.not("line = ? AND eline = ?",5, 5)
            @dog1=@dog1.offset( rand(@dog1.count) ).first
            
            @maxline2=5-@dog1.line
            @maxeline2=5-@dog1.eline
            @dog2=Dog.where(classid: [@leader,9], level: @level2, line: 0..@maxline2, eline: 0..@maxeline2, priority: [nil,2]).where("manalimit > ?", mana).where.not(kind1: @dog1.kind1, kind2: @dog1.kind1)
            @dog2=@dog2.offset( rand(@dog2.count) ).first
            
          else 
            @level1=rand(1..@levelmax-2)
            @level2=rand(1..@levelmax-@level1-1)
            @level3=@levelmax-@level1-@level2
            
            @dog1=Dog.where(classid: [@leader,9],level: @level1, priority: [nil,1]).where("manamin < ?", mana).where.not("line = ? OR eline = ?",5, 5)
            @dog1=@dog1.offset( rand(@dog1.count) ).first
            
            @maxline2=5 - @dog1.line
            @maxeline2=5 - @dog1.eline
            @dog2=Dog.where(classid: [@leader,9], level: @level2, line: 0..@maxline2, eline: 0..@maxeline2, priority: nil).where.not("line = ? AND eline = ?",@maxline2, @maxeline2).where.not(kind1: @dog1.kind1, kind2: @dog1.kind1)
            @dog2=@dog2.offset( rand(@dog2.count) ).first
            
            @maxline3=5-@dog1.line-@dog2.line
            @maxeline3=5-@dog1.eline-@dog2.eline
            @dog3=Dog.where(classid: [@leader,9], level: @level3, line: 0..@maxline3, eline: 0..@maxeline3, priority: [nil,2]).where("manalimit > ?", mana).where.not(kind1: [@dog1.kind1,@dog2.kind1], kind2: [@dog1.kind1,@dog2.kind1])
            @dog3=@dog3.offset( rand(@dog3.count) ).first      
          end
        
        # 写真合成
          image_a = MiniMagick::Image.open("public/user_images/#{@user.image}")
          image_a.resize '295x350!'
          
          image_b = MiniMagick::Image.open('./app/assets/oricamaker/frame/1.png')
          image_b.resize '295x350!'
          
          composite_image = image_a.composite(image_b) do |config|
          config.compose "Over"
          config.gravity "center"
          config.geometry "+0+0"
          end
          
          image_c = MiniMagick::Image.open("./app/assets/oricamaker/leader/#{@leader}.jpg")
          
          composite_image = image_c.composite(composite_image) do |config|
          config.compose "Over"
          config.gravity "center"
          config.geometry "-335+60"
          end
          
          image_d = MiniMagick::Image.open("./app/assets/oricamaker/mana/#{@mana}.png")
          image_d.resize '100x100!'
          
          composite_image = composite_image.composite(image_d) do |config|
          config.compose "Over"
          config.gravity "center"
          config.geometry "-475-140"
          end
          
          image_e = MiniMagick::Image.open("./app/assets/oricamaker/attack/#{@attack}.png")
          image_e.resize '100x100!'
          
          composite_image = composite_image.composite(image_e) do |config|
          config.compose "Over"
          config.gravity "center"
          config.geometry "-470+215"
          end
          
          image_f = MiniMagick::Image.open("./app/assets/oricamaker/health/#{@health}.png")
          image_f.resize '100x100!'
          
          composite_image = composite_image.composite(image_f) do |config|
          config.compose "Over"
          config.gravity "center"
          config.geometry "-200+220"
          end
          composite_image.write("public/user_images/#{@user.image}")
        
        # コメント１名前１
          image = MiniMagick::Image.open("public/user_images/#{@user.image}")
          pos = '-320, -135'
          @user = User.find_by(id: params[:id])
          text = @user.user_name
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#ffffff'
          config.gravity 'center'
          if text.length < 9
            config.pointsize 26
          elsif text.length < 10
            config.pointsize 24
          elsif text.length < 11
            config.pointsize 22
          elsif text.length < 12
            config.pointsize 20
          elsif text.length < 13
            config.pointsize 18
          elsif text.length < 14
            config.pointsize 16
          else
            config.pointsize 15
          end
          config.draw "text #{pos} '#{text}'"
          end
          
        # コメント２スタッツ
          pos1 = '371, -139'
          pos2 = '460, -140'
          pos3 = '371, +59'
          pos4 = '460, +58'
          pos5 = '372, -140'
          pos6 = '461, -141'
          pos7 = '372, +60'
          pos8 = '461, +59'
          text1 = @attack
          text2= @health
          text3= attack+2
          text4= health+2
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#ffffff'
          config.gravity 'center'
          config.pointsize 30
          config.draw "text #{pos1} '#{text1}'"
          config.draw "text #{pos2} '#{text2}'"
          config.draw "text #{pos3} '#{text3}'"
          config.draw "text #{pos4} '#{text4}'"
          config.draw "text #{pos5} '#{text1}'"
          config.draw "text #{pos6} '#{text2}'"
          config.draw "text #{pos7} '#{text3}'"
          config.draw "text #{pos8} '#{text4}'"
          end
          
          
        # コメント３名前２
          pos = '90, 70'
          text = @user.user_name
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#ffffff'
          config.gravity 'northwest'
          config.pointsize 38
          config.draw "text #{pos} '#{text}'"
          end
        
    # コメント４ 進化前
          @kigou="+-/ 1234567890｡､EPXYZ"
          pos = '500, 222'
          text = @dog1.content
      unless text==nil
          text = text.gsub(/@user_name/, "#{@user.user_name}")
           # 改行調整 半角調整

          text1 = text[0,29]
          @minus1=text1.count(@kigou)/2
          @length1=text.length - @minus1
          
          text2 = text[29+@minus1,29]
          if text2 != nil
          @minus2=text2.count(@kigou)/2
          @length2=text.length - @minus1 - @minus2
          
          text3 = text[58+@minus1+@minus2,29]
          if text3 != nil
          @minus3=text3.count(@kigou)/2
          @length3=text.length - @minus1 - @minus2 - @minus3
          
          text4 = text[87+@minus1+@minus2+@minus3,29]
          if text4 != nil
          @minus4=text4.count(@kigou)/2
          @length4=text.length - @minus1 - @minus2 - @minus3 - @minus4
          end
          end
          end
          
          if @length1 <= 30
            text=text
          elsif @length2 <= 59
            text = text.insert(29+@minus1,"\n")
          elsif @length3 <= 88
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
          elsif @length4 <= 117
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
          else
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
            text = text.insert(119+@minus1+@minus2+@minus3+@minus4,"\n")
          end
          
          bold4 = @dog1.bold4
          if bold4 != nil
          @bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFD700'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
          
        # コメント５
          @tin=[@dog1.bold1,@dog1.bold2,@dog1.bold3,@bold4]
          @tin=@tin.compact
          @tin.each do |tintin|
          @sora="　"*tintin.length
          text = text.gsub(/#{tintin}/, "#{@sora}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFFFFF'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
      end
      
         # コメント６進化後
          pos = '500, 419'
          text = @dog1.evolve
      unless text==nil
          text = text.gsub(/@user_name/, "#{@user.user_name}")
          
           # 改行調整 半角調整

          text1 = text[0,29]
          @minus1=text1.count(@kigou)/2
          @length1=text.length - @minus1
          
          text2 = text[29+@minus1,29]
          if text2 != nil
          @minus2=text2.count(@kigou)/2
          @length2=text.length - @minus1 - @minus2
          
          text3 = text[58+@minus1+@minus2,29]
          if text3 != nil
          @minus3=text3.count(@kigou)/2
          @length3=text.length - @minus1 - @minus2 - @minus3
          
          text4 = text[87+@minus1+@minus2+@minus3,29]
          if text4 != nil
          @minus4=text4.count(@kigou)/2
          @length4=text.length - @minus1 - @minus2 - @minus3 - @minus4
          end
          end
          end
          
          if @length1 <= 30
            text=text
          elsif @length2 <= 59
            text = text.insert(29+@minus1,"\n")
          elsif @length3 <= 88
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
          elsif @length4 <= 117
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
          else
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
            text = text.insert(119+@minus1+@minus2+@minus3+@minus4,"\n")
          end
          
          bold4 = @dog1.bold4
          if bold4 != nil
          @bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          bold4 = @dog1.bold4
          if bold4 != nil
          bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFCC00'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
          
        # コメント７
          @tin=[@dog1.bold1,@dog1.bold2,@dog1.bold3,bold4]
          @tin=@tin.compact
          @tin.each do |tintin|
          @sora="　"*tintin.length
          text = text.gsub(/#{tintin}/, "#{@sora}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFFFFF'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
      end
      
    # コメント４４ 進化前
     if @bun >= 2
          line=@dog1.line
          @tate = 222+25*line
          pos = "500, #{@tate}"
          
          text = @dog2.content
      unless text==nil
          text = text.gsub(/@user_name/, "#{@user.user_name}")
           # 改行調整 半角調整

          text1 = text[0,29]
          @minus1=text1.count(@kigou)/2
          @length1=text.length - @minus1
          
          text2 = text[29+@minus1,29]
          if text2 != nil
          @minus2=text2.count(@kigou)/2
          @length2=text.length - @minus1 - @minus2
          
          text3 = text[58+@minus1+@minus2,29]
          if text3 != nil
          @minus3=text3.count(@kigou)/2
          @length3=text.length - @minus1 - @minus2 - @minus3
          
          text4 = text[87+@minus1+@minus2+@minus3,29]
          if text4 != nil
          @minus4=text4.count(@kigou)/2
          @length4=text.length - @minus1 - @minus2 - @minus3 - @minus4
          end
          end
          end
          
          if @length1 <= 30
            text=text
          elsif @length2 <= 59
            text = text.insert(29+@minus1,"\n")
          elsif @length3 <= 88
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
          elsif @length4 <= 117
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
          else
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
            text = text.insert(119+@minus1+@minus2+@minus3+@minus4,"\n")
          end
          
          bold4 = @dog1.bold4
          if bold4 != nil
          @bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          bold4 = @dog2.bold4
          if bold4 != nil
          bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFCC00'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
          
        # コメント５５
          @tin=[@dog2.bold1,@dog2.bold2,@dog2.bold3,bold4]
          @tin=@tin.compact
          @tin.each do |tintin|
          @sora="　"*tintin.length
          text = text.gsub(/#{tintin}/, "#{@sora}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFFFFF'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
      end
      
         # コメント６６進化後
         
          eline=@dog1.eline
          @tate = 419+25*eline
          pos = "500, #{@tate}"
          
          text = @dog2.evolve
      unless text==nil
          text = text.gsub(/@user_name/, "#{@user.user_name}")
          
           # 改行調整 半角調整

          text1 = text[0,29]
          @minus1=text1.count(@kigou)/2
          @length1=text.length - @minus1
          
          text2 = text[29+@minus1,29]
          if text2 != nil
          @minus2=text2.count(@kigou)/2
          @length2=text.length - @minus1 - @minus2
          
          text3 = text[58+@minus1+@minus2,29]
          if text3 != nil
          @minus3=text3.count(@kigou)/2
          @length3=text.length - @minus1 - @minus2 - @minus3
          
          text4 = text[87+@minus1+@minus2+@minus3,29]
          if text4 != nil
          @minus4=text4.count(@kigou)/2
          @length4=text.length - @minus1 - @minus2 - @minus3 - @minus4
          end
          end
          end
          
          if @length1 <= 30
            text=text
          elsif @length2 <= 59
            text = text.insert(29+@minus1,"\n")
          elsif @length3 <= 88
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
          elsif @length4 <= 117
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
          else
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
            text = text.insert(119+@minus1+@minus2+@minus3+@minus4,"\n")
          end
          
          bold4 = @dog1.bold4
          if bold4 != nil
          @bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          bold4 = @dog2.bold4
          if bold4 != nil
          bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFCC00'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
          
        # コメント７７
          @tin=[@dog2.bold1,@dog2.bold2,@dog2.bold3,bold4]
          @tin=@tin.compact
          @tin.each do |tintin|
          @sora="　"*tintin.length
          text = text.gsub(/#{tintin}/, "#{@sora}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFFFFF'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
      end
     end
     
    # コメント４４４ 進化前
     if @bun == 3
          line=@dog1.line+@dog2.line
          @tate = 222+25*line
          pos = "500, #{@tate}"
          
          text = @dog3.content
      unless text==nil
          text = text.gsub(/@user_name/, "#{@user.user_name}")
           # 改行調整 半角調整

          text1 = text[0,29]
          @minus1=text1.count(@kigou)/2
          @length1=text.length - @minus1
          
          text2 = text[29+@minus1,29]
          if text2 != nil
          @minus2=text2.count(@kigou)/2
          @length2=text.length - @minus1 - @minus2
          
          text3 = text[58+@minus1+@minus2,29]
          if text3 != nil
          @minus3=text3.count(@kigou)/2
          @length3=text.length - @minus1 - @minus2 - @minus3
          
          text4 = text[87+@minus1+@minus2+@minus3,29]
          if text4 != nil
          @minus4=text4.count(@kigou)/2
          @length4=text.length - @minus1 - @minus2 - @minus3 - @minus4
          end
          end
          end
          
          if @length1 <= 30
            text=text
          elsif @length2 <= 59
            text = text.insert(29+@minus1,"\n")
          elsif @length3 <= 88
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
          elsif @length4 <= 117
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
          else
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
            text = text.insert(119+@minus1+@minus2+@minus3+@minus4,"\n")
          end
          
          bold4 = @dog1.bold4
          if bold4 != nil
          @bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          bold4 = @dog3.bold4
          if bold4 != nil
          bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFCC00'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
          
        # コメント５５５
          @tin=[@dog3.bold1,@dog3.bold2,@dog3.bold3,bold4]
          @tin=@tin.compact
          @tin.each do |tintin|
          @sora="　"*tintin.length
          text = text.gsub(/#{tintin}/, "#{@sora}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFFFFF'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
      end
      
         # コメント６６６進化後
          eline=@dog1.eline+@dog2.eline
          @tate = 419+25*eline
          pos = "500, #{@tate}"
          
          text = @dog3.evolve
      unless text==nil
          text = text.gsub(/@user_name/, "#{@user.user_name}")
          
           # 改行調整 半角調整

          text1 = text[0,29]
          @minus1=text1.count(@kigou)/2
          @length1=text.length - @minus1
          
          text2 = text[29+@minus1,29]
          if text2 != nil
          @minus2=text2.count(@kigou)/2
          @length2=text.length - @minus1 - @minus2
          
          text3 = text[58+@minus1+@minus2,29]
          if text3 != nil
          @minus3=text3.count(@kigou)/2
          @length3=text.length - @minus1 - @minus2 - @minus3
          
          text4 = text[87+@minus1+@minus2+@minus3,29]
          if text4 != nil
          @minus4=text4.count(@kigou)/2
          @length4=text.length - @minus1 - @minus2 - @minus3 - @minus4
          end
          end
          end
          
          if @length1 <= 30
            text=text
          elsif @length2 <= 59
            text = text.insert(29+@minus1,"\n")
          elsif @length3 <= 88
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
          elsif @length4 <= 117
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
          else
            text = text.insert(29+@minus1,"\n")
            text = text.insert(59+@minus1+@minus2,"\n")
            text = text.insert(89+@minus1+@minus2+@minus3,"\n")
            text = text.insert(119+@minus1+@minus2+@minus3+@minus4,"\n")
          end
          
          bold4 = @dog1.bold4
          if bold4 != nil
          @bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          bold4 = @dog3.bold4
          if bold4 != nil
          bold4 =bold4.gsub(/@user_name/, "#{@user.user_name}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFCC00'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
          
        # コメント７７７
          @tin=[@dog3.bold1,@dog3.bold2,@dog3.bold3,bold4]
          @tin=@tin.compact
          @tin.each do |tintin|
          @sora="　"*tintin.length
          text = text.gsub(/#{tintin}/, "#{@sora}")
          end
          
          image.combine_options do |config|
          config.font './app/assets/fonts/ipaexm.ttf'
          config.fill '#FFFFFF'
          config.gravity 'northwest'
          config.pointsize 19
          config.interline_spacing 6
          config.draw "text #{pos} '#{text}'"
          end
      end
     end
      
          image.write("public/user_images/#{@user.image}")
       
          flash[:notice] = "ユーザー情報を編集しました"
          redirect_to("/users/#{@user.id}/show")
  else
    render("users/new")
  end
end


def create
    @user = User.new(
      image: 'default_user.jpg',
      user_name: params[:user_name]
      ) 
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/index")
    end
end


end