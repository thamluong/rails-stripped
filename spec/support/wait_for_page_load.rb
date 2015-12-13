module WaitForPageLoad
  
  def wait_until
    Timeout.timeout(10) do
      sleep(0.1) until value = yield
      value
    end
  end
  
  def click_link_after_page_load(link_text)
    wait_until_page_has_text(link_text)
    
    click_link link_text
  end  
  
  def wait_until_page_has_text(text)
    begin
      wait_until do
        expect(page).to have_content(text)
      end          
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      sleep 0.1
      retry
    end        
  end
  
end