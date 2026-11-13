# Bài nộp LAB5 — T1 Y tế · Nhóm [điền tên nhóm]

**Lớp:** [L3A/L3B] · **Bàn / zone:** [điền] · **Track:** T1 — Y tế

| Họ và Tên | Mã Học Viên | Việc đã làm |
|---|---|---|
| Khương Hoàng Nguyên | 2A202603987 | [Điền việc thực tế] |
| [Thành viên 2] | [Mã học viên] | [Điền việc thực tế] |
| [Thành viên 3] | [Mã học viên] | [Điền việc thực tế] |

> Phạm vi bản này: chặng 1–3. Tình huống và lời thoại là dữ liệu dựng cho bài thiết kế, không phải tư vấn y tế hay mô tả một hệ thống đang chạy. Phần nhóm, mã học viên và việc thực tế cần được nhóm điền.

## §1. Lát cắt & phạm vi

**Lát cắt của track:** Trong **kênh chat Hỏi dược sĩ của Pharmacity**, khi **khách** đang nhắn hỏi “tôi (hoặc người nhà) bị X, có thuốc gì không”, **AI tự trả lời và gợi ý sản phẩm, hỏi thêm câu sàng lọc, hay chuyển dược sĩ, khuyên đi khám ngay**, để người dùng thuốc không nhận sai sản phẩm và ca nguy hiểm không nằm trong hàng chờ. Nguồn: [`tracks/t1-healthcare.md`](tracks/t1-healthcare.md), mục “Lát cắt”.

**Quyết định sản phẩm:** Kênh hiện có AI trả lời thông tin giá, tồn kho, khuyến mãi và chuyển câu chuyên môn cho dược sĩ. Lát cắt này thêm khả năng AI chọn *đường đi* cho câu hỏi về triệu chứng. Người nhắn có thể hỏi thay trẻ nhỏ hoặc người nhà; người chịu hậu quả là người dùng thuốc. Nếu gợi ý nhầm và thuốc đã được dùng, không thể thu hồi tác động; chuyển thừa chỉ tốn thời gian. Vì vậy, khi chưa biết rõ người dùng thuốc hoặc thấy dấu hiệu nguy hiểm, giao diện phải dừng đường gợi ý sản phẩm trước khi hiện nút đặt. Đây là suy luận từ mục “Bối cảnh”, bảng tool và “Rubric riêng” của track.

**Ba việc tính năng không làm:**

1. **Không bán hoặc gợi ý thuốc thay thế cho thuốc kê đơn qua chat AI.** `ban_thuoc_ke_don` không đảo được; xác nhận của khách không thay thế đánh giá chuyên môn.
2. **Không tự đưa liều dùng hay khẳng định thuốc an toàn cho trẻ nhỏ, người mang thai hoặc người có bệnh nền.** Track không cung cấp dữ liệu lâm sàng, và gợi ý sai có thể gây hại sau khi dùng; chuyển dược sĩ để đánh giá.
3. **Không tự lưu thông tin sức khoẻ vào hồ sơ khách.** `luu_ghi_chu_suc_khoe` có thể xoá nhưng rủi ro lộ đã phát sinh; chỉ xem xét sau một lựa chọn đồng ý riêng của khách ở chặng thiết kế mức tự chủ.

Giới hạn dữ liệu: track chỉ cấp mô tả tool và tin mồi, không cấp hồ sơ thuốc, chống chỉ định, toa hay tồn kho cho một cửa hàng cụ thể. Do đó mọi khẳng định về sản phẩm phù hợp, mức tồn hoặc tính an toàn đều thiếu căn cứ trong bài này.

## §2. Kịch bản rủi ro  (chặng 2)
Nhãn đánh giá **mức hại nếu lỗi xảy ra**, không phải xác suất xảy ra. ① nguồn sự thật; ② mơ hồ/thiếu thông tin; ③ ngoài phạm vi/thẩm quyền; ④ đặc thù y tế. Các tin nhắn dưới đây đều là dữ liệu dựng.

| # | Tin người dùng nhắn | Lớp; tên lỗi | AI có thể sai thế nào — căn cứ trong track | Sản phẩm tốt nên làm gì | Nhãn |
|---|---|---|---|---|---|
| S3 | “Bé sốt, cho mình thuốc hạ sốt nào, đặt luôn nhé.” | ②; đoán người dùng thuốc | Tin thiếu tuổi, thời gian sốt, thuốc đã dùng và dấu hiệu nguy hiểm; `goi_y_san_pham` có nút đặt. AI có thể chọn thuốc cho trẻ trước khi hỏi. | Hỏi ngắn về tuổi và dấu hiệu nguy hiểm trước; không hiện gợi ý/nút đặt, chuyển dược sĩ 
| S6 | “Lưu bệnh và dị ứng của ba mình vào hồ sơ để lần sau khỏi kể.” | ③; lưu dữ liệu của người khác | `luu_ghi_chu_suc_khoe` lưu vào hồ sơ khách, còn tin nói về *ba*; xoá được nhưng rủi ro lộ vẫn còn. AI có thể lưu ngay hoặc nhập sai chủ thể. | Không lưu; giải thích cần sự đồng ý phù hợp và xác định đúng hồ sơ trước khi có thao tác lưu. | Không chấp nhận được |
| S7 | “Ba mình đau ngực, hơi khó thở, tiện cho mình loại thuốc nào, đặt luôn nhé.” | ④; trấn an và bán trong ca nguy hiểm | `goi_y_san_pham` có thể hiện nút đặt; `khuyen_di_kham` có thể hiện cảnh báo. Nếu AI ưu tiên yêu cầu mua hoặc `chuyen_duoc_si` vào hàng chờ, dấu hiệu “đau ngực, khó thở” trong “Rubric riêng” bị bỏ qua. | **Hiện cảnh báo đi khám/gọi cấp cứu ngay; chặn gợi ý và nút đặt; không yêu cầu chờ dược sĩ trước khi hành động. | Không chấp nhận được |
| S10 | “Gần nhà còn nước muối sinh lý không, tối mình qua lấy.” | ①; bịa tồn kho | Tin mồi hỏi cửa hàng gần nhà, nhưng fixture không có vị trí hoặc tồn kho theo chi nhánh; AI có thể tự nói “còn hàng”. | Hỏi cửa hàng hoặc vị trí, nói rõ chưa kiểm tra được tồn kho; không tự bịa trạng thái. | Sửa được |

## §3. Khi AI sai  (chặng 3)
Với mỗi kịch bản đắt nhất:
- AI nói gì (nguyên văn) · người dùng thấy gì · làm gì tiếp · ai được báo, sau bao lâu.
- Quyết định: hỏi lại / trả lời kèm giới hạn / dừng và chuyển người — chọn cách nào, đã loại cách nào, vì sao.
- Loại lỗi (hệ thống / người dùng / ngữ cảnh) và vì sao cách nói, cách sửa đi theo loại đó.
- 2–3 nguyên tắc HAX/PAIR, mỗi cái trỏ vào một chỗ cụ thể (câu chữ hoặc chỗ trên màn hình).
- Lỗi nào sửa câu chữ không cứu được (nếu có), và thiết kế cứu nó thế nào.

## §4. Mức tự chủ  (chặng 4)
Với mỗi tool:
- Mức của nhóm (tự làm / cần người duyệt / cấm). Nếu cần người duyệt: ai duyệt · người duyệt thấy gì · quá hạn thì sao.
- Lý do theo cost-of-error: sai thì ai chịu gì · đảo lại được không · chờ người thì mất gì.
- Phương án đã cân nhắc và vì sao loại.
Thêm:
- Tool khó xếp nhất: mỗi người từng chọn gì, cái giá của mỗi phía (trỏ về kịch bản ở §2), nhóm chốt thế nào.
- Thử mức đã đặt trên 2 kịch bản đắt nhất + 1 kịch bản bình thường: cái sai có bị chặn không? còn việc nào làm khi lẽ ra phải hỏi? người dùng bình thường có phải chờ vô ích không?
- Luật thêm hoặc tool tách bước (nếu có), và vì sao.
- Một mức tự chủ đã đổi lời hứa nào với người dùng.

## §5. Prototype  (chặng 5)
- Link hoặc file · công cụ · phần nào mock · có lời gọi AI thật không.
- 1–2 ảnh có đánh số; mỗi số: thể hiện gì · nguyên tắc HAX/PAIR nào · mức tự chủ nào.
- Quyết định: cách hiện độ chắc/bằng chứng và điều khiển mức tự chủ — đã nghĩ tới cách nào khác, vì sao chọn cách này.

## §6. Tốt là gì  (chặng 6 — nhẹ, bỏ được nếu thiếu giờ)
- 3 tiêu chí Pass/Fail chấm được; thiết kế của nhóm đạt tiêu chí nào trên 2 kịch bản đắt nhất; lỗi còn lại.

## §7. Demo
- Ca lạ nhận được ở demo: prototype đã làm gì, và nhóm có đổi ý gì sau ca đó không.
