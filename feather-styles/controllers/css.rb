class Css < Application
  def custom
    css = ""
    Style.all.each do |style|
      css << style.content + "\n\n"
    end
    self.status = 200
    self.headers["Content-Type"] = "text/css"
    self.body = css
    css
  end
end