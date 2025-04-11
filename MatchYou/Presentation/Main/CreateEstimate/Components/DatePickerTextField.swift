//
//  DatePickerTextField.swift
//  MatchYou
//
//  Created by 김견 on 4/9/25.
//


import UIKit
import SnapKit

final class DatePickerTextField: UIView {

    // MARK: - Properties
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()

    var selectedDate: Date? {
        return datePicker.date
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }

    // MARK: - UI
    private func setUI() {
        self.addSubview(textField)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")

        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([done], animated: true)

        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
        textField.placeholder = "날짜 선택"
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }

    // MARK: - Actions
    @objc private func doneTapped() {
        textField.text = dateFormatter.string(from: datePicker.date)
        textField.resignFirstResponder()
    }
}
