module OpSSL
  class OpSSL
    def initializer
    end

    def genpkey(user, pass)
      IO.popen("openssl genpkey -algorithm RSA -out ~/.keysdat/"+user.to_s+"_pkey.pem -aes-256-cbc -pass pass:"+pass.to_s) do |f|
        f.close
        $?.to_i == 0
      end
    end

    def genpbkey(user, pass)
      IO.popen("openssl rsa -pubout -in ~/.keysdat/"+user.to_s+"_pkey.pem -passin pass:"+pass.to_s+" -out ~/.keysdat/"+user.to_s+"_pbkey.pem") do |f|
        f.close
        $?.to_i == 0
      end
    end

    def encrypt(user, data)
      IO.popen("echo '"+data.to_s+"' | openssl rsautl -encrypt -inkey ~/.keysdat/"+user.to_s+"_pbkey.pem -pubin | xxd -p -c 999") do |f|
        f.gets
      end
    end

    def decrypt(user, pass, data)
      IO.popen("echo '"+data.to_s+"' | xxd -p -r | openssl rsautl -decrypt -inkey ~/.keysdat/"+user.to_s+"_pkey.pem -passin pass:"+pass.to_s) do |f|
        dat = f.gets 
        dat.chomp if dat.present?
      end
    end

    def del_pub(user)
      IO.popen("rm ~/.keysdat/"+user.to_s+"_pbkey.pem")
    end

    def del_pkey(user)
      IO.popen("rm ~/.keysdat/"+user.to_s+"_pkey.pem")
    end
  end
end