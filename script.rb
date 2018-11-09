require 'csv'
require 'date'
require 'fileutils'
require_relative 'mailgun'
# require 'google/apis/sheets_v4'
# require 'googleauth'
# require 'googleauth/stores/file_token_store'
# require_relative 'gsheet'


def read_csv
    birthday_dictionary = []
    # read out each line of CSV
    CSV.foreach("birthdays.csv", quote_char: '"', col_sep: ',', row_sep: :auto, headers: true) do |row|
        
        birthday_object = {
            first: row[0],
            last: row[1],
            birthdate: row[2]
        }
        birthday_dictionary.push(birthday_object)
    end
    
    return birthday_dictionary
end

def compare_dates
    dict = read_csv()
    today = DateTime.now
    dict.each do | person |
        birthday = DateTime.strptime(person[:birthdate], '%m-%d-%Y')
        same_month = birthday.month === today.month
        timeframe = birthday.day - today.day
        within_week = timeframe >= 7

        same_month && within_week ? send_birthday_message(person[:first], person[:last], timeframe) : puts('No birthdays')
    end
end

# To-Do: 
# hook up Google API
# refactor to OO? 

# start
compare_dates()