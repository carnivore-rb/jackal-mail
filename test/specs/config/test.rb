Configuration.new do

  jackal do
    require ["carnivore-actor", "jackal-mail"]

    mail do
      config do
      end

      sources do
        input  { type 'actor' }
        output { type 'spec' }
      end

      callbacks ['Jackal::Mail::Smtp']
    end
  end

end
