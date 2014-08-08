module ScreenshotHelpers
  def screenshot_dir_path
    File.join Rails.root, 'features', 'screenshots'
  end
  
  def screenshot_take(file_name)
    file_path = File.join screenshot_dir_path, "#{file_name}.png"
    page.save_screenshot file_path
    puts "Screenshot is taken to #{file_path}"
  end
end

World(ScreenshotHelpers)
