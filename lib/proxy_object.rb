module ProxyObject

  def proxy(message, target, target_message=message)
    proxies[message] << [target, target_message]

    file, line = caller.first.split(':')

    instance_eval %{
      def #{message}(*args, &block)
        proxies[:#{message}].each do |target, message|
          target.send(message, *args, &block)
        end
      end
    }, file, line.to_i
  end

  def proxies
    @proxies ||= Hash.new([])
  end

end
