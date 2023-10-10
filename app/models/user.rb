class User < ApplicationRecord
  before_save :format_cpf_and_phone
  validates :cpf, presence: true, format: { with: /\A(\d{3}.){2}\d{3}-\d{2}|\d{11}\z/, message: "O formato do CPF é inválido" }
  validates :phone, presence: true, format: { with: /\A((\d{2})\s?\d{4,5}-\d{4}|\d{10,11})\z/, message: "O formato do telefone é inválido" }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "O formato do email é inválido" }
  validates :name, presence: true
  validates :cpf, uniqueness: true
  validates :email, uniqueness: true
  validates :phone, uniqueness: true

  def self.search(term)
    term_without_formatting = term.gsub(/[\.-]/, '')
    where('name LIKE :term OR email LIKE :term OR phone LIKE :term OR cpf LIKE :term', term: "%#{term}%")
  end


  private

  def format_cpf_and_phone
    # Formata o CPF para o formato 123.456.789-00
    self.cpf = cpf.scan(/\d/).join.insert(3, '.').insert(7, '.').insert(11, '-') if cpf.present?

    # Formata o telefone para o formato (XX) XXXXX-XXXX ou (XX) XXXX-XXXX
    digits = phone.scan(/\d/)
    if digits.size == 11
      self.phone = "#{digits[0..1].join} #{digits[2..6].join}-#{digits[7..10].join}"
    elsif digits.size == 10
      self.phone = "#{digits[0..1].join} #{digits[2..5].join}-#{digits[6..9].join}"
    end
  end
end
