class PageFinder < HighVoltage::PageFinder
  def find
    "#{super}-#{I18n.locale}"
  end
end
