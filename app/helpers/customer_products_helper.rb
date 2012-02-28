module CustomerProductsHelper


  def ranges_links(price_range)
    if not price_range.empty? 
      differance = price_range[1] - price_range[0]
      ranges = []
      if differance > 1000
        ranges = subdivide_ranges(price_range,1000)
      elsif differance > 100
        ranges = subdivide_ranges(price_range,100)
      end
      s = ""
      for r in ranges do
        link_name = r[0].to_s + "-" + r[1].to_s
        s += ("<div>"+link_to(link_name, search_customer_products_path(Hash[params].update('price_range'=>link_name)))+"</div>\n")
      end
      s.html_safe
    end
  end
  private
  def subdivide_ranges(price_range,step)
      ranges = []
      min = price_range[0] - price_range[0]%step
      index=0
      while min + step <= price_range[1]
        max = min + step
        range = [min,max] 
        ranges[index]=range
        min = max
        index += 1
      end
      max = min+step
      range = [min,max] 
      ranges[index]=range
      ranges
  
  end
end
