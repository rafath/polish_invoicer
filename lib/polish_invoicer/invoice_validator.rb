# encoding: utf-8
module PolishInvoicer
  class InvoiceValidator
    attr_reader :errors

    def initialize(invoice)
      @invoice = invoice
      @errors = {}
    end

    def valid?
      @errors = {}
      check_presence
      check_not_nil
      check_dates
      check_arrays
      check_booleans
      check_price
      check_vat
      @errors.empty?
    end

    protected
      def check_presence
        check_blank(:number, 'Numer nie może być pusty')
        check_blank(:create_date, 'Data wystawienia nie może być pusta')
        check_blank(:trade_date, 'Data sprzedaży nie może być pusta')
        check_blank(:seller, 'Sprzedawca nie może być pusty')
        check_blank(:buyer, 'Nabywca nie może być pusty')
        check_blank(:item_name, 'Nazwa usługi nie może być pusta')
        check_blank(:price, 'Cena nie może być pusta')
        check_blank(:vat, 'Stawka VAT nie może być pusta')
        check_blank(:created_by, 'Konieczne jest podanie osoby wystawiającej dokument')
        check_blank(:payment_type, 'Rodzaj płatności nie może być pusty')
        check_blank(:payment_date, 'Termin płatności nie może być pusty')
      end

      def check_not_nil
        @errors[:gross_price] = 'Konieczne jest ustawienie znacznika rodzaju ceny (netto/brutto)' if @invoice.gross_price.nil?
        @errors[:paid] = 'Konieczne jest ustawienie znacznika opłacenia faktury' if @invoice.paid.nil?
      end

      def check_arrays
        @errors[:seller] = 'Sprzedawca musi być podany jako tablica stringów' unless @invoice.seller.is_a?(Array)
        @errors[:buyer] = 'Nabywca musi być podany jako tablica stringów' unless @invoice.buyer.is_a?(Array)
      end

      def check_booleans
        unless [true, false].include?(@invoice.gross_price)
          @errors[:gross_price] = 'Znacznik rodzaju ceny musi być podany jako boolean'
        end
        unless [true, false].include?(@invoice.paid)
          @errors[:paid] = 'Znacznik opłacenia faktury musi być podany jako boolean'
        end
      end

      def check_dates
        @errors[:create_date] = 'Data wystawienia musi być typu Date' unless @invoice.create_date.is_a?(Date)
        @errors[:trade_date] = 'Data sprzedaży musi być typu Date' unless @invoice.trade_date.is_a?(Date)
        @errors[:payment_date] = 'Termin płatności musi być typu Date' unless @invoice.payment_date.is_a?(Date)
      end

      def check_price
        unless @invoice.price.is_a?(Numeric)
          @errors[:price] = 'Cena musi być liczbą'
        else
          @errors[:price] = 'Cena musi być liczbą dodatnią' unless @invoice.price > 0
        end
      end

      def check_vat
        unless Vat.valid?(@invoice.vat)
          @errors[:vat] = 'Stawka VAT spoza listy dopuszczalnych wartości'
        else
          if Vat.zw?(@invoice.vat) and blank?(@invoice.pkwiu)
            @errors[:pkwiu] = 'Konieczne jest podanie podstawy prawnej zwolnienia z podatku VAT'
          end
        end
      end

      def blank?(value)
        value.to_s.strip == ''
      end

      def check_blank(key, msg)
        value = @invoice.send(key)
        @errors[key] = msg if blank?(value)
      end
  end
end