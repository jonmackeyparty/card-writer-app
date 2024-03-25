require 'rmagick'
require 'pry'
require 'fileutils'
DIRECTS = ["HOLLISWOOD_CENTER", "BROOKLYN_CENTER", "BUSHWICK_CENTER", "RICHMOND_CENTER"]
CARDS = ["card6.png", "card7.png", "card8.png", "card9.png", "card10.png"]

class CardWriter < ActiveRecord::Base

  def self.card_art_printer
    path = "/Users/donotdestroy/dev/card-wr-ter-app/CARD_ART/cards/"
    50.times do
      system("lpr", path + CARDS.sample) or raise "lpr failed"
    end
  end

  def self.new_random_letter_printer(dir)
    write_dir = ENV['WRITE_DIR']
    directory = Dir::glob(write_dir)
    blank = ENV['BLANK']
    puts directory.count
    50.times do
      file1 = directory.sample
      file2 = directory.sample
      file_to_fit1 = Magick::ImageList.new(file1).resize(2450, 1550)
      file_to_fit2 = Magick::ImageList.new(file2).resize(2450, 1550)
      img = Magick::ImageList.new(blank)
      final = img.composite(file_to_fit1, 0, 0, Magick::AtopCompositeOp)
      final2 = final.composite(file_to_fit2, 0, 1680, Magick::AtopCompositeOp)
      final2.write('printjob.jpg')
      system("lpr", 'printjob.jpg') or raise "lpr failed"
      sleep(5)
    end
  end

  def self.convert_images_from_directory(directory_path)
    Dir.foreach(directory_path) do |filename|
      full_path = directory_path + '/' + filename
      save_path = directory_path + '/converted_files/' + filename.gsub(".png","" ).gsub(".jpg","").gsub(".jpeg","").gsub(".JPG","") + "_convert.jpg"
      next if filename == '.' or filename == '..' or filename == '.DS_Store' or filename.include?('.pdf') or filename.include?('convert') or File.exist?(save_path)
      puts full_path
      img = Magick::ImageList.new(full_path)
      img = img.negate.threshold(Magick::QuantumRange*0.8).negate
      img.write(save_path){quality=50}
    end
  end

  def self.convert_individual_images(image_file)
    img = Magick::ImageList.new(image_file)
    img = img.negate.threshold(Magick::QuantumRange*0.55).negate
    img.write("#{image_file}_convert.jpg")
  end

  def self.filename_cleanup(dir)
    Dir.glob("/Users/donotdestroy/dev/card-wr-ter-app" + "/" + dir + "/*").each do |f|
      filename = File.basename(f, File.extname(f))
      changed_name = filename.downcase.gsub(" ", "").gsub(".", "_").gsub("-","_")
      puts dir + "-" + changed_name
      File.rename(f, "/Users/donotdestroy/dev/card-wr-ter-app/" + dir + "/" + changed_name + File.extname(f).downcase)
    end
  end

  def self.rotate_by_dim(directory)
    directory_path = "/Users/donotdestroy/dev/card-wr-ter-app/" + directory + "/converted"
    Dir.foreach(directory_path) do |filename|
      full_path = directory_path + '/' + filename
      next if !filename.include?('converted')
      puts full_path
      img = Magick::Image.read(full_path)[0]
      width, height = img.columns, img.rows
      if width > height
        img.rotate!(90)
        img.write(full_path)
      end
    end
  end
end

#for x in *.png; do convert -define jpeg:size=800x800 $x -thumbnail '800x800>' -background white -gravity center -extent 100x100 $x ./scaled/$x; done
