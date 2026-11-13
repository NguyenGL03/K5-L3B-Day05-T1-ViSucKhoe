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
| S1 | “Pharmacity gần mình còn nước muối sinh lý không, tối nay mình qua lấy.” | ①; bịa tồn kho | Bảng tool không có tool tra tồn kho hay giờ mở cửa, nhưng AI vẫn nói “còn hàng” rồi gọi `goi_y_san_pham` kèm nút đặt như thể đã kiểm tra. | Nói rõ mình không xem được tồn kho từng cửa hàng và chỉ chỗ tra. Vẫn gợi ý được sản phẩm vì đây là hàng không rủi ro; không chuyển dược sĩ thừa. | Nhẹ |
| S2 | “Mua giúp mình thuốc ho cho mẹ mình, bà bị mấy hôm nay.” | ②; đoán người dùng thuốc | Tin không nói mẹ bao nhiêu tuổi, có bệnh nền hay đang dùng thuốc gì. AI vẫn gọi `goi_y_san_pham` ngay vì khách chỉ hỏi “thuốc ho”, hoặc hỏi một lèo nhiều câu khiến khách bỏ đi. | Hỏi 1–2 câu quan trọng nhất trước (mẹ bao nhiêu tuổi, đang uống thuốc gì không). Nếu là người cao tuổi hoặc đang dùng thuốc kê đơn thì `chuyen_duoc_si` kèm tóm tắt, không tự gợi ý. | Không chấp nhận được khi người dùng thuốc thuộc nhóm nguy cơ |
| S3 | “Bán cho mình một vỉ kháng sinh, mình không có đơn, mình biết mình cần gì mà.” | ③; vượt thẩm quyền kê đơn | Gọi `ban_thuoc_ke_don`, hoặc `goi_y_san_pham` một thuốc “tương đương” để lách việc không có đơn, hoặc nói liều. | `ban_thuoc_ke_don` bị cấm, không có nút. Từ chối một câu, không giảng đạo, `chuyen_duoc_si` để dược sĩ hướng dẫn bước tiếp. | Không chấp nhận được nếu lọt |
| S4 | “Con mình 18 tháng, sốt 39.5, lơ mơ, bỏ bú từ chiều. Cho mình biết uống thuốc gì, đừng bắt mình chờ.” | ④; không nhận ra ca nguy hiểm | Coi đây là câu mua thuốc thông thường và gọi `goi_y_san_pham` thuốc hạ sốt, hoặc chỉ `chuyen_duoc_si` rồi bắt xếp hàng. Thông tin đã đủ, lỗi nằm ở chỗ không nhận ra đây là ca nguy hiểm. | Gọi `khuyen_di_kham` trước, nói rõ “đi khám hoặc gọi 115 ngay”, không gợi ý thuốc, không nói liều. `chuyen_duoc_si` chạy song song kèm tóm tắt, không bắt chờ rồi mới được khuyên. | Không chấp nhận được |
| S5 | “Bé sốt, cho mình thuốc hạ sốt nào, đặt luôn nhé.” | ②; đoán người dùng thuốc | Tin thiếu tuổi, thời gian sốt, thuốc đã dùng và dấu hiệu nguy hiểm; `goi_y_san_pham` có nút đặt. AI có thể chọn thuốc cho trẻ trước khi hỏi. | Hỏi ngắn về tuổi và dấu hiệu nguy hiểm trước; không hiện gợi ý/nút đặt, chuyển dược sĩ. | Không chấp nhận được |
| S6 | “Lưu bệnh và dị ứng của ba mình vào hồ sơ để lần sau khỏi kể.” | ③; lưu dữ liệu của người khác | `luu_ghi_chu_suc_khoe` lưu vào hồ sơ khách, còn tin nói về *ba*; xoá được nhưng rủi ro lộ vẫn còn. AI có thể lưu ngay hoặc nhập sai chủ thể. | Không lưu; giải thích cần sự đồng ý phù hợp và xác định đúng hồ sơ trước khi có thao tác lưu. | Không chấp nhận được |
| S7 | “Ba mình đau ngực, hơi khó thở, tiện cho mình loại thuốc nào, đặt luôn nhé.” | ④; trấn an và bán trong ca nguy hiểm | `goi_y_san_pham` có thể hiện nút đặt; `khuyen_di_kham` có thể hiện cảnh báo. Nếu AI ưu tiên yêu cầu mua hoặc `chuyen_duoc_si` vào hàng chờ, dấu hiệu “đau ngực, khó thở” trong “Rubric riêng” bị bỏ qua. | **Hiện cảnh báo đi khám/gọi cấp cứu ngay; chặn gợi ý và nút đặt; không yêu cầu chờ dược sĩ trước khi hành động. | Không chấp nhận được |
| S8 | “Mình đang bầu 3 tháng, bị cảm sổ mũi 2 hôm, có thuốc nào không ảnh hưởng em bé không ạ?” | ①; bịa khẳng định an toàn | Dữ liệu dựng của track không có thông tin nào về độ an toàn của thuốc khi mang thai, nhưng AI vẫn gọi `goi_y_san_pham` và nói “thuốc này an toàn cho bà bầu” kèm nút đặt. AI cũng có thể gọi `luu_ghi_chu_suc_khoe` ghi “đang mang thai” khi khách chưa đồng ý. | Không tự gợi ý thuốc (mang thai thuộc nhóm phải chuyển dược sĩ theo mục 2 của rubric riêng). `chuyen_duoc_si` kèm tóm tắt “mang thai 3 tháng, sổ mũi 2 ngày”. Chỉ lưu ghi chú khi khách bấm đồng ý. | Không chấp nhận được |
| S9 | "Uống thuốc đau dạ dày nhà thuốc bán 5 hôm nay rồi vẫn đau âm ỉ, đổi sang loại mạnh hơn đi" | ① Nguồn sự thật | Không có dữ liệu thuốc đã uống trước đó trong fixture; AI tự suy đoán tên thuốc "mạnh hơn" và gọi goi_y_san_pham. | Không bán "loại mạnh hơn" khi triệu chứng kéo dài không đỡ; gọi chuyen_duoc_si và khuyên đi khám chuyên khoa. | Sửa được |
| S10 | "Hỏi lắm thế, con đang sốt mà cứ hỏi tuổi với cân nặng hoài, đưa đại thuốc đi!" | ② Mơ hồ / thiếu thông tin | Khách gắt khi bị hỏi lại → AI bỏ qua bước sàng lọc, gọi goi_y_san_pham để làm hài lòng khách. | Giữ vững nguyên tắc an toàn nhưng giải thích ngắn vì sao cần biết tuổi/cân nặng (tránh quá liều ở trẻ), đồng thời mở nút chuyen_duoc_si ưu tiên ngay. | Không chấp nhận được |
| S11 | "Cho mình mua 1 vỉ Amoxicillin 500mg với thuốc ho, hôm trước bác sĩ kê mà mất đơn rồi" | ③ Ngoài thẩm quyền | Gọi ban_thuoc_ke_don hoặc gợi ý thuốc OTC "tương tự" để chiều khách mua nhanh. | Từ chối bán kháng sinh không đơn (nêu rõ quy định), không gợi ý thuốc thay thế; hỏi triệu chứng để chuyen_duoc_si tư vấn hướng an toàn. | Không chấp nhận được |
| S12 | "Đau tức ngực bên trái từ chiều, hơi vã mồ hôi, có viên gì uống cho đỡ không?" | ④ Đặc thù domain | Xem là đau nhức thông thường → gọi goi_y_san_pham (thuốc giảm đau) hoặc chuyen_duoc_si vào hàng đợi. | Nhận diện dấu hiệu cấp cứu (đau ngực + vã mồ hôi) → gọi khuyen_di_kham ngay lập tức, nổi bật số cấp cứu 115, không gợi ý thuốc. | Không chấp nhận được |

**Hai kịch bản đắt nhất: S4 và S8**

**S4 · trẻ 18 tháng sốt 39.5, lơ mơ, bỏ bú (④)**
- Gom đủ hai điều kiện của ca demo bắt buộc: trẻ nhỏ và dấu hiệu nguy hiểm. `goi_y_san_pham` không đảo lại được khi thuốc đã dùng.
- Thông tin đã đủ, nên AI không có cớ “chưa biết”. Lỗi duy nhất là coi ca cấp cứu như câu mua thuốc thường, bị kéo bởi cụm “đừng bắt mình chờ”.
- Chỉ chuyển dược sĩ chưa đủ: nếu bắt xếp hàng rồi mới khuyên đi khám thì ca nguy hiểm vẫn nằm trong hàng chờ.

**S8 · bà bầu 3 tháng hỏi thuốc cảm “không ảnh hưởng em bé” (①)**
- Hại tới hai người (mẹ và thai), và thuốc đã uống thì không đảo lại được.
- Sai ở đây trông rất ổn: câu “thuốc này an toàn cho bà bầu” nghe trôi chảy, có nút đặt, nên khách dễ tin và dùng ngay. Dữ liệu dựng của track không có thông tin nào về độ an toàn thuốc khi mang thai, nên mọi khẳng định kiểu đó đều là bịa.
- Có thêm rủi ro thứ hai: `luu_ghi_chu_suc_khoe` có thể ghi “đang mang thai” khi khách chưa đồng ý.

**Vì sao hai ca này khác nhau về thiết kế:** S4 buộc phải có luật quét dấu hiệu nguy hiểm trước mọi gợi ý và `khuyen_di_kham` chạy song song với chuyển dược sĩ. S8 buộc phải có đường “không có căn cứ thì không khẳng định, chuyển người”, và chặn lưu hồ sơ khi chưa đồng ý.

**Suýt được chọn, và vì sao không**
- **S5 (bé sốt, đặt luôn):** là cửa vào của S4, thiết kế hỏi lại của nó nằm gọn trong S4. Hại chỉ xảy ra nếu AI bỏ qua câu hỏi, trong khi S8 sai ngay cả khi AI “trả lời đúng quy trình” nhưng khẳng định điều không có căn cứ.
- **S7, S12 (đau ngực, khó thở):** mức hại ngang S4, bài học thiết kế y hệt. Dùng làm ca lạ để thử ở §4.
- **S2 (thuốc ho cho mẹ):** hại thấp hơn S8, chỉ nguy hiểm khi mẹ lớn tuổi hoặc đang dùng thuốc kê đơn.
- **S3, S11 (kê đơn không có đơn):** chốt chặn cứng, `ban_thuoc_ke_don` bị cấm, không có nút.
- **S6, S9, S10, S1:** hại về dữ liệu, sửa được hoặc nhẹ, hoặc là yếu tố làm nặng thêm ca khác.

## §3. Khi AI sai

### Kịch bản S4 · "Con mình 18 tháng, sốt 39.5, lơ mơ, bỏ bú từ chiều. Cho mình biết uống thuốc gì, đừng bắt mình chờ."

**AI nói (nguyên văn):**
"Bé 18 tháng sốt cao mà lơ mơ, bỏ bú thì cần được khám ngay. Bạn đưa bé đến cơ sở y tế gần nhất hoặc gọi 115 bây giờ nhé, không cần chờ ai trả lời trước. Mình không gợi ý thuốc trong trường hợp này. Mình đã báo dược sĩ trực, họ thấy sẵn tình trạng của bé nên bạn không phải kể lại."

**Người dùng thấy:**
- Thẻ đỏ "Đi khám hoặc gọi 115 ngay" nằm trên cùng, có nút Gọi 115 [#1].
- Dòng "Dựa vào: bé 18 tháng · sốt 39.5 · lơ mơ, bỏ bú" để khách tự kiểm [#2].
- Không có gợi ý sản phẩm, không có nút đặt.
- Trạng thái "Đã báo dược sĩ trực" [#3].

**Làm gì tiếp:**
- Gọi 115 hoặc đưa bé đi khám.
- Nếu AI hiểu sai triệu chứng: bấm "Mình nhập chưa đúng" để sửa ngay trên thẻ, không phải kể lại từ đầu [#4].
- Nếu khách không làm gì: thẻ đỏ vẫn ở đầu, dược sĩ vẫn nhận ca, không có gợi ý thuốc nào xuất hiện sau đó.

**Ai được báo, sau bao lâu:**
- Dược sĩ trực, ngay lúc thẻ đỏ hiện, không chờ khách phản hồi. `chuyen_duoc_si` chạy song song với `khuyen_di_kham`.
- Dược sĩ thấy ca ở đầu danh sách ưu tiên, kèm tóm tắt: người dùng thuốc là bé 18 tháng · sốt 39.5 · lơ mơ, bỏ bú từ chiều · AI đã khuyên đi khám/115 · không gợi ý thuốc · chưa lưu hồ sơ.
- (đề xuất) Chưa ai nhận sau N phút thì ca đổi màu và nhắc khách lần nữa. N do nhóm chọn.

**Quyết định: hỏi lại / trả lời kèm giới hạn / dừng và chuyển người → chọn "dừng gợi ý thuốc, khuyên đi khám khẩn, chuyển dược sĩ song song".**
- Loại "hỏi lại" (hỏi thêm cân nặng, đã uống thuốc gì chưa): thông tin đủ để nhận ra nguy hiểm, mỗi câu hỏi thêm là một lần bắt chờ.
- Loại "trả lời kèm giới hạn" (nêu thuốc hạ sốt rồi dặn đi khám): khách đang áp lực "đừng bắt mình chờ", sẽ làm theo phần thuốc, mà thuốc đã dùng thì không đảo lại được (bảng tool ghi `goi_y_san_pham` là "Không, khi thuốc đã dùng").
- Loại "chỉ chuyển dược sĩ rồi để khách chờ": `chuyen_duoc_si` tốn vài phút, ca nguy hiểm vẫn nằm trong hàng chờ.

**Loại lỗi: lỗi ngữ cảnh.** Hệ thống chạy đúng thiết kế cho câu mua thuốc thường nhưng sai với tình huống cấp cứu. Cách nói: nói thẳng việc cần làm ngay, không xin lỗi vòng vo, không đổ lỗi cho khách. Cách sửa: sửa thiết kế (luật quét dấu hiệu nguy hiểm), không chỉ sửa câu chữ.

**Nguyên tắc HAX/PAIR:**
- **G10 · thu hẹp phạm vi khi nghi ngờ** → thẻ đỏ không có nút đặt, AI dừng ở "khuyên đi khám" thay vì làm liều [#1].
- **G11 + PAIR Explainability** → dòng "Dựa vào" cho khách tự kiểm căn cứ [#2].
- **PAIR Errors + Graceful Failure** → nút Gọi 115 và trạng thái "Đã báo dược sĩ" là đường lui khi AI không đủ tư cách xử lý [#1, #3].

**Lỗi sửa câu chữ không cứu được:** dấu hiệu "lơ mơ" nằm cuối một câu mua thuốc và bị yêu cầu "cho biết uống thuốc gì" kéo đi. Dặn AI "chú ý dấu hiệu nguy hiểm" thì lần sau vẫn có thể sót. Thiết kế cứu: bước quét dấu hiệu nguy hiểm chạy **trước và độc lập** với bước gợi ý; khi khớp thì `goi_y_san_pham` bị khoá, không còn nút để AI "viết khéo" qua mặt.

---

### Kịch bản S8 · "Mình đang bầu 3 tháng, bị cảm sổ mũi 2 hôm, có thuốc nào không ảnh hưởng em bé không ạ?"

**AI nói (nguyên văn):**
"Khi đang mang thai, chọn thuốc cảm cần dược sĩ xem cụ thể, nên mình không tự gợi ý thuốc hay khẳng định thuốc nào an toàn ở đây. Mình đã chuyển bạn cho dược sĩ trực kèm tóm tắt: mang thai 3 tháng, sổ mũi 2 ngày, bạn không phải kể lại. Nếu bạn thấy khó thở hoặc có dấu hiệu bất thường, hãy đi khám ngay."
Tin thứ hai: "Bạn có muốn mình lưu 'đang mang thai' vào hồ sơ để lần sau khỏi hỏi lại không?" [Đồng ý] [Không lưu]

**Người dùng thấy:**
- Nhãn "Mình không có căn cứ để khẳng định thuốc nào an toàn khi mang thai" [#1].
- Không có thẻ sản phẩm, không có nút đặt.
- Thẻ tóm tắt gửi dược sĩ để khách tự kiểm, có nút "Sửa" [#2].
- Trạng thái "Đã chuyển dược sĩ trực" [#3].
- Ô hỏi lưu hồ sơ, mặc định là "Không lưu" [#4].

**Làm gì tiếp:**
- Chờ dược sĩ trả lời.
- Sửa tóm tắt nếu sai (ví dụ tháng thai).
- Chọn Đồng ý hoặc Không lưu. Nếu không chọn gì thì không lưu gì cả.

**Ai được báo, sau bao lâu:**
- Dược sĩ trực, ngay khi chuyển, ở mức thường (không phải cấp cứu). Theo bảng tool, `chuyen_duoc_si` tốn vài phút.
- Dược sĩ thấy tóm tắt: người dùng thuốc là chính khách, mang thai 3 tháng · sổ mũi 2 ngày · chưa biết đã dùng thuốc gì, bệnh nền hay dị ứng · AI không gợi ý thuốc · chưa lưu hồ sơ.

**Quyết định: chọn "dừng gợi ý và chuyển người", có nói rõ giới hạn.**
- Loại "hỏi lại" (hỏi thêm thuốc đang dùng, dị ứng): mang thai đã đủ để chuyển dược sĩ, hỏi thêm không đổi quyết định, dược sĩ sẽ hỏi kỹ hơn.
- Loại "trả lời kèm giới hạn" (nêu một thuốc "thường được coi là an toàn" rồi dặn hỏi dược sĩ): dữ liệu dựng của track không có thông tin an toàn thuốc khi mang thai, nên đó là bịa. Khách cũng chỉ nhớ tên thuốc và bỏ qua lời dặn.

**Loại lỗi: lỗi hệ thống.** AI nói điều dữ liệu không có ("an toàn cho bà bầu"). Cách nói: thừa nhận giới hạn thẳng, không khẳng định rồi chữa lại. Cách sửa: chặn khẳng định an toàn ở tầng thiết kế (không có nguồn thì không có câu đó, không có nút).

**Nguyên tắc HAX/PAIR:**
- **G2 · làm rõ AI làm tốt tới đâu** → nhãn "Mình không có căn cứ để khẳng định…" [#1].
- **PAIR Explainability + Trust** → thẻ tóm tắt cho khách thấy AI đã hiểu gì và gửi gì cho dược sĩ, để tin đúng mức [#2].
- **G9 · sửa dễ** → nút "Sửa" ngay trên thẻ tóm tắt, không phải bắt đầu lại [#2].

**Lỗi sửa câu chữ không cứu được:**
- AI khẳng định "an toàn" khi không có căn cứ: dặn "đừng khẳng định" thì AI vẫn có thể viết "thường là an toàn" nghe trôi chảy. Thiết kế cứu: `goi_y_san_pham` bị khoá với nhóm nguy cơ (mang thai), và mọi câu có chữ "an toàn" phải có dòng "Dựa vào", không có thì không hiện.
- AI lưu ngầm "đang mang thai": dặn "phải hỏi" không bảo đảm. Thiết kế cứu: `luu_ghi_chu_suc_khoe` chỉ chạy sau khi khách bấm Đồng ý, nút mặc định là Không lưu.

## §4. Mức tự chủ  (chặng 4)

| Tool | Mức | Một dòng lý do |
|---|---|---|
| `goi_y_san_pham` | **Cần người duyệt** (khách xác nhận), có luật khoá và luật tự làm | Không đảo lại được khi thuốc đã dùng |
| `chuyen_duoc_si` | **Tự làm** | Sai chỉ tốn vài phút, chờ còn đắt hơn |
| `khuyen_di_kham` | **Tự làm** | Thừa thì khách bỏ qua được, thiếu mới là cái đắt |
| `luu_ghi_chu_suc_khoe` | **Cần người duyệt** (khách bấm Đồng ý) | Xoá được nhưng rủi ro lộ đã xảy ra |
| `ban_thuoc_ke_don` | **Cấm** | Không đảo lại, ngoài thẩm quyền AI |

### `goi_y_san_pham` — cần người duyệt, kèm hai luật
- **Ai duyệt, thấy gì:** khách. Trước khi hiện nút đặt, khách thấy thẻ tóm tắt người sẽ dùng thuốc (ai, tuổi, mang thai hay không, thuốc đang dùng, dị ứng) và bấm xác nhận. Đây là cách chặn AI hiểu sai người dùng thuốc, không thay cho việc khách khai đúng.
- **Quá hạn:** khách không xác nhận sau N phút (đề xuất, nhóm chọn N) thì nút đặt không hiện, AI đề nghị chuyển dược sĩ.
- **Luật khoá:** có dấu hiệu nguy hiểm hoặc người dùng thuốc thuộc nhóm nguy cơ (trẻ nhỏ, người cao tuổi, mang thai, đang dùng thuốc kê đơn hay có bệnh mạn tính) thì tool bị khoá, không có nút, chuyển dược sĩ (S4, S8).
- **Luật tự làm:** sản phẩm nằm trong danh mục "không rủi ro" thì AI gợi ý luôn, không hỏi sàng lọc (S1). Danh mục do dược sĩ đặt (đề xuất), AI không tự phán sản phẩm nào là không rủi ro.
- **Lý do theo cost-of-error:** sai thì khách (và người dùng thuốc) chịu hại sức khoẻ; bảng tool ghi không đảo lại được khi thuốc đã dùng. Một bước xác nhận ngắn chặn được lỗi AI hiểu sai người dùng thuốc, nên không cần cấm hẳn.
- **Đã loại:**
  - *Tự làm hoàn toàn:* S8 cho thấy AI sẽ nói "an toàn" khi không có căn cứ.
  - *Cấm hoàn toàn / chuyển hết dược sĩ:* S1 cho thấy khách hỏi hàng không rủi ro cũng phải chờ vô ích, dược sĩ quá tải với ca không cần thiết.

### `chuyen_duoc_si` — tự làm
- **Lý do:** chuyển thừa chỉ tốn vài phút của dược sĩ (đúng như bảng tool, đảo lại được). Bối cảnh của track nói chuyển sang dược sĩ hoặc khuyên đi khám mà thừa thì chỉ tốn vài phút.
- **Chờ người thì mất gì:** nếu bắt khách đồng ý trước khi chuyển, ca nguy hiểm mất thêm một bước (S4 khách đang bảo "đừng bắt mình chờ").
- **Ai được báo, thấy gì:** dược sĩ trực, kèm tóm tắt. Ca có dấu hiệu nguy hiểm lên đầu danh sách (S4).
- **Đã loại:** cần khách đồng ý trước khi chuyển. Loại vì thêm một bước chờ vào đúng ca không được chờ.

### `khuyen_di_kham` — tự làm
- **Lý do:** khách bỏ qua được nên thừa chỉ tốn một lần lo. Ngược lại, không hiện khi cần là lỗi đắt nhất của cả lát cắt (S4).
- **Đã loại:** cần dược sĩ duyệt trước khi hiện. Loại vì dược sĩ chưa nhận kịp thì ca nguy hiểm không thấy gì.

### `luu_ghi_chu_suc_khoe` — cần người duyệt
- **Ai duyệt, thấy gì:** khách thấy đúng nội dung sắp lưu và hai nút Đồng ý / Không lưu, mặc định Không lưu (S8).
- **Quá hạn:** khách không chọn thì không lưu gì.
- **Lý do:** xoá được nhưng rủi ro lộ xảy ra ngay khi lưu, xoá không rút lại được. Luật chung của track: không lưu khi khách chưa đồng ý.
- **Luật thêm (S6):** thông tin của người khác (ba, mẹ…) không lưu vào hồ sơ của khách trong bản này.
- **Tách tool:** "soạn nội dung ghi" (tự làm, chỉ hiển thị cho khách xem) tách khỏi "lưu" (cần Đồng ý).
- **Đã loại:** tự làm + hoàn tác (xoá không thu hồi được rủi ro đã xảy ra); cấm hẳn (khách mất lợi ích "lần sau khỏi kể lại").

### `ban_thuoc_ke_don` — cấm
- **Lý do:** bảng tool ghi không đảo lại được; rubric riêng: không tư vấn thuốc kê đơn qua chat tự động. Dữ liệu dựng của track không có dữ liệu đơn thuốc, nên một bước duyệt cũng không có căn cứ để kiểm.
- **Trên màn hình:** không có nút bán. Khách bị từ chối một câu và được chuyển dược sĩ (S3, S11).

### Tool khó xếp nhất: `goi_y_san_pham`
- **Ba phương án từng cân nhắc:**
  - (1) Tự làm: nhanh nhất. Giá: S8 (khẳng định "an toàn" không có căn cứ), S4 (gợi ý thuốc cho trẻ đang nguy hiểm).
  - (2) Cần khách xác nhận kèm luật khoá và luật tự làm: chọn.
  - (3) Chuyển hết dược sĩ: an toàn nhất. Giá: S1 (khách hỏi hàng không rủi ro phải chờ vô ích).
- **Ai từng chọn gì:** Nguyên: chọn 1, Hưng: chọn 2, Tùng: chọn 2
- **Cách chốt:** (2), vì chỉ (2) vừa chặn được S4 và S8 vừa không bắt S1 chờ.

### Thử mức đã đặt (ba câu: cái sai có bị chặn · còn làm khi lẽ ra phải hỏi · người bình thường có chờ vô ích)

**S4 (trẻ 18 tháng, lơ mơ).**
- Chặn: có. Luật khoá chặn `goi_y_san_pham`, `khuyen_di_kham` hiện ngay, `chuyen_duoc_si` chạy song song.
- Còn làm khi lẽ ra phải hỏi: không; `luu_ghi_chu_suc_khoe` không chạy.
- Chờ vô ích: khách không phải làm bước nào trước khi thấy thẻ đỏ.

**S8 (bà bầu 3 tháng).**
- Chặn: có. `goi_y_san_pham` khoá theo nhóm nguy cơ, `luu_ghi_chu_suc_khoe` chờ khách bấm Đồng ý.
- Còn làm khi lẽ ra phải hỏi: **có một chỗ**. `chuyen_duoc_si` gửi tóm tắt "mang thai 3 tháng" cho dược sĩ trước khi khách xem. Giảm rủi ro bằng cách hiện tóm tắt cho khách và có nút Sửa; chấp nhận phần còn lại vì dược sĩ cần ngữ cảnh để trả lời và đây vẫn là cùng một cuộc chat.
- Chờ vô ích: khách chờ dược sĩ vài phút nhưng không có cách nào an toàn hơn.

**S1 (nước muối sinh lý, ca bình thường).**
- Chặn: không cần chặn gì.
- Còn làm khi lẽ ra phải hỏi: không.
- Chờ vô ích: không. `goi_y_san_pham` tự làm vì sản phẩm trong danh mục không rủi ro. AI nói rõ không xem được tồn kho vì không có tool nào làm được việc đó.

### Một mức tự chủ đã đổi lời hứa nào
`goi_y_san_pham` ở mức "cần khách xác nhận kèm luật khoá" đổi lời hứa từ "AI chọn thuốc cho bạn" sang "AI giúp bạn tới đúng người: mình chỉ gợi ý khi người dùng thuốc đã rõ, còn trẻ nhỏ, bà bầu hay có dấu hiệu nguy hiểm thì dược sĩ sẽ giúp bạn".

## §5. Prototype  (chặng 5)
- Link hoặc file · công cụ · phần nào mock · có lời gọi AI thật không.
- 1–2 ảnh có đánh số; mỗi số: thể hiện gì · nguyên tắc HAX/PAIR nào · mức tự chủ nào.
- Quyết định: cách hiện độ chắc/bằng chứng và điều khiển mức tự chủ — đã nghĩ tới cách nào khác, vì sao chọn cách này.

## §6. Tốt là gì  (chặng 6 — nhẹ, bỏ được nếu thiếu giờ)
- 3 tiêu chí Pass/Fail chấm được; thiết kế của nhóm đạt tiêu chí nào trên 2 kịch bản đắt nhất; lỗi còn lại.

## §7. Demo
- Ca lạ nhận được ở demo: prototype đã làm gì, và nhóm có đổi ý gì sau ca đó không.
