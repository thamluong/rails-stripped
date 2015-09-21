module StripeExceptionHandler
  def run_with_exception_handler(log_message, user_message)
    begin
      yield
    rescue Exception => e
      StripeLogger.error "#{log_message} #{e.message}. #{e.backtrace.join("\n")}"
      redisplay_form(user_message)
    end
  end
  
  def run_with_stripe_exception_handler(log_message, user_message, main, cleanup=nil)
    begin
      main.call
      true
    rescue Striped::CreditCardDeclined => e
      StripeLogger.error "#{log_message} #{e.message}. #{e.backtrace.join("\n")}"
      redisplay_form(e.message)
    rescue Striped::CreditCardException, Exception => e
      StripeLogger.error "#{log_message} #{e.message}. #{e.backtrace.join("\n")}"
      redisplay_form(user_message)
    ensure
      cleanup.call if cleanup
    end    
  end
  
  def redisplay_form(message)
    @error_message = message
    
    render :new and return
  end
  
end