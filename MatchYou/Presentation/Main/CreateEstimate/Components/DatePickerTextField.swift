import UIKit

final class DatePickerTextField: UITextField {

    // MARK: - Properties
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // 외부에서 날짜 값 가져올 수 있게
    var selectedDate: Date? {
        return datePicker.date
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([done], animated: true)

        self.inputView = datePicker
        self.inputAccessoryView = toolbar
        self.placeholder = "날짜 선택"
    }

    // MARK: - Actions
    @objc private func doneTapped() {
        self.text = dateFormatter.string(from: datePicker.date)
        self.resignFirstResponder()
    }
}
