require 'sinatra'
require 'sequel'

require_relative '../queue/connection'
require_relative '../lib/monkey_patch'


DB = Sequel.connect(adapter: 'postgres', host: 'localhost', port: 5432, database: 'fx_transactions', user: 'leon', password: ENV['DB_PASSWORD'])

get '/transactions' do
    result = DB[:transactions]
    # return all the records from the people table as json
    return result.all.to_json(decimals:2)
end

get '/transactions/:id' do
    transactions = DB[:transactions]
    result = transactions.where(id: params["id"])
    # return all the records from the people table as json
    return result.to_json
end

post '/transactions' do
    params = JSON.parse request.body.read
    customer_id = params["customer_id"].to_i
    input_amount = params["input_amount"]
    input_currency = params["input_currency"]
    output_amount = params["output_amount"]
    output_currency = params["output_currency"]
    
    #result = DB["INSERT INTO transactions (customer_id, input_amount,input_currency,output_amount,output_currency) VALUES (?, ?,?,?,?)", customer_id, input_amount, input_currency, output_amount, output_currency]
    
    #result.insert(1)
    result = DB[:transactions]
    result.insert(customer_id: customer_id, input_amount: input_amount, input_currency: input_currency, output_amount: output_amount, output_currency: output_currency)

    QueueConnection.publish(params.to_json)
    return "Transaction added"
end
