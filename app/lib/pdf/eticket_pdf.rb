# frozen_string_literal: true
require 'prawn/qrcode'
require 'prawn/measurement_extensions'

module Pdf
  class EticketPdf < Prawn::Document # rubocop:disable Metrics/ClassLength

    include ActiveSupport::NumberHelper

    PADDING = 7
    QUANTITY_FORMAT = '%.1f %s'

    PRICE_ROW_HEIGHT = 22

    DOCUMENT_MARGIN = [23, 46, 23, 46].freeze

    def initialize(options)
      super(margin: DOCUMENT_MARGIN)
      default_leading(3)

      font_families.update(
        'Montserrat' => {
          normal: "#{Rails.root}/app/assets/fonts/Montserrat-Regular.ttf",
          bold: "#{Rails.root}/app/assets/fonts/Montserrat-Bold.ttf",
          extrabold: "#{Rails.root}/app/assets/fonts/Montserrat-ExtraBold.ttf"
        }
      )

      @participant = options[:participant]
      @tickets = Ticket.where(participant: @participant)
    end

    def build
      font 'Montserrat'

      @currency = '$'

      create_logo_and_event_info
      create_header
      generate_qr_codes
    end

    def create_logo_and_event_info
      bounding_box([0, cursor], width: 900 - PADDING, height: 120) do
        define_grid(columns: 4, rows: 1)

        grid(0, 0, column_width: 10).bounding_box do
          logo_section
        end

        grid(0, 1).bounding_box do
          create_event_detail_section
        end
      end

      move_down(20)
      stroke_color '94A3B8'
      line_width 0.5
      stroke_horizontal_rule
    end

    def logo_section
      move_down(25)
      image("#{Rails.root}/app/assets/images/druk_canada_logo.png", position: :center, width: 100)
    end

    def create_event_detail_section
      text("SUMMER GALA", color: '94A3B8', size: 12, style: :bold)
      move_down(10)
      font_size(7) do
        details = []
        details << [
          { content: 'DATE', borders: [], text_color: '94A3B8' },
          { content: '1st July 2022', borders: [] }
        ]
        details << [
          { content: 'Time', borders: [], text_color: '94A3B8' },
          { content: '4:30 PM ET', borders: [] }
        ]
        details << [
          { content: 'DRESS CODE', borders: [], text_color: '94A3B8', width: 65 },
          { content: 'National Dress', borders: [] }
        ]
        details << [
          { content: 'VENUE', borders: [], text_color: '94A3B8' },
          { content: 'Lithuanian House Toronto, 1573 Bloor St West, M6P1A6', borders: [] }
        ]

        table(details)
      end
    end

    def create_header
      move_down(20)
      bounding_box([PADDING, cursor], width: bounds.right - PADDING, height: 180) do
        define_grid(columns: 2, rows: 1, gutter: PADDING)

        grid(0, 0).bounding_box do
          create_participant_info
        end

        grid(0, 1).bounding_box do
          create_ticket_table
        end
      end
    end

    def create_participant_info
      move_down(10)
      text("TICKET DETAILS:", color: '94A3B8', size: 12)
      move_down(10)

      font_size(7) do
        details = []
        details << [
          { content: 'NAME', borders: [], text_color: '94A3B8' },
          { content: @participant.full_name, borders: [] }
        ]
        details << [
          { content: 'EMAIL', borders: [], text_color: '94A3B8' },
          { content: @participant.email, borders: [] }
        ]
        details << [
          { content: 'PHONE', borders: [], text_color: '94A3B8', width: 65 },
          { content: @participant.phone_no, borders: [] }
        ]
        details << [
          { content: 'ADDRESS', borders: [], text_color: '94A3B8' },
          { content: @participant.phone_no, borders: [] }
        ]

        table(details)
      end
    end

    def create_ticket_table
      move_down(10)
      text("TICKET DETAILS:", color: '94A3B8', size: 12)
      move_down(10)
      items_rows = []
      items_rows << [
        { content: 'ITEM', borders: [], size: 8, width: 60, background_color: 'F8F9FA' },
        { content: 'QTY', borders: [], size: 8, width: 40, background_color: 'F8F9FA' },
        { content: 'PRICE', borders: [], size: 8, width: 40, background_color: 'F8F9FA' },
        { content: 'TOTAL', borders: [], size: 8, width: 40, background_color: 'F8F9FA' }
      ]

      adult_tickets = @tickets.where(age_group: :adult)
      adult_tickets_total = 0
      if adult_tickets.present? && adult_tickets.count > 0
        adult_tickets_total += (50 * adult_tickets.count)
        items_rows << [
          {
            content: 'Adult Tickets', borders: [], size: 8
          },
          {
            content: "#{adult_tickets.count}", borders: [], size: 8
          },
          {
            content: "$50", borders: [], size: 8, align: :right
          },
          {
            content: "$#{adult_tickets_total}", borders: [], size: 8, align: :right
          }
        ]
      end

      children_tickets = @tickets.where(age_group: :children)
      children_tickets_total = 0
      if children_tickets.present? && children_tickets.count > 0
        children_tickets_total += (20 * adult_tickets.count)
        items_rows << [
          {
            content: 'Children Tickets', borders: [], size: 8
          },
          {
            content: "#{children_tickets.count}", borders: [], size: 8
          },
          {
            content: "$20", borders: [], size: 8, align: :right
          },
          {
            content: "$#{children_tickets_total}", borders: [], size: 8, align: :right
          }
        ]
      end

      items_rows << [{ content: '', borders: [], colspan: 4 }]

      grand_total = adult_tickets_total + children_tickets_total
      items_rows << [{ content: 'Grand Total', borders: [], font_style: :bold, size: 8 },
                     { content: "$#{grand_total}", borders: [], font_style: :bold, size: 8,
                       colspan: 3, align: :right }]
      table(items_rows)
    end

    def generate_qr_codes
      cnt = 0
      @tickets.each do |ticket|
        cnt += 1
        puts "generating QR code for: #{ticket.age_group}"
        qrcode = RQRCode::QRCode.new(ticket.ticket_number, size: 20)
        move_down(20)
        render_qr_code(qrcode, dot: 1.2, align: :center)
        move_down(10)
        text "#{cnt}. #{ticket.age_group.capitalize} Ticket # #{ticket.ticket_number}", align: :center
        start_new_page if cnt.even?
      end
    end

  end
end
