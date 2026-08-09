# LeetCode #20 — Valid Parentheses

> **Zorluk:** Easy · **Konular:** Stack, String · **Pattern:** Stack ile eşleştirme (LIFO)
> **Çözüm tarihi:** 2026-08-09 · **Sözel algoritma 4/4 kendi kurdu; zorluk koda çevirmede**

---

## 1. Problem
`(){}[]` karakterlerinden oluşan string `s` geçerli mi? Her açılan **aynı türden** ve **doğru sırada** kapanmalı.
`"()"`→true · `"()[]{}"`→true · `"(]"`→false · `"([)]"`→false · `"{[]}"`→true

---

## 2. Approach Evolution

### Approach 0 — Sayaç (ÇALIŞMAZ, ama öğretici)
Her türden açılış/kapanış say, eşitse geçerli de.
- **Neden çöker:** `"([)]"` → her türden 1+1, sayaçlar tutar → "geçerli" der. Ama **geçersiz**.
- **Ders:** Sayma **sırayı/iç içeliği** kaybeder. Bu bir sayma değil, **nesting** problemi → stack şart. (Tek tür parantez olsaydı sayaç yeterdi, O(1) space.)

### Approach 1 — Tekrarlı çift silme (BRUTE FORCE, doğru ama yavaş)
Yan yana geçerli çiftleri (`()`,`[]`,`{}`) sil; silme oldukça baştan tekrarla. Sonda boşsa geçerli.
```
"{[]}" → "[]" sil → "{}" → "" → geçerli ✓
"([)]" → yan yana geçerli çift yok → boş değil → geçersiz ✓
```
- **Time:** O(n²) — her tarama O(n), her turda ≥1 çift silinir → ≤ n/2 tur (string silme maliyetiyle daha kötü) · **Space:** O(n)
- **Reject:** Doğru ama tekrar tekrar baştan tarıyor. Stack aynı işi **tek geçişte** yapar — çünkü "hangi açılışlar bekliyor" bilgisini taşır, her seferinde aramaya gerek kalmaz.

### Approach 2 — Stack (OPTIMAL)
"**En son açılan, ilk kapanmalı**" → birebir **LIFO**. Stack'in her andaki hâli = "şu an hâlâ açık olanlar". O(n)/O(n).

---

## 3. Çözüm

```swift
func isValid(_ s: String) -> Bool {
    var stack: [Character] = []
    let pairs: [Character: Character] = [")": "(", "]": "[", "}": "{"]

    for char in s {
        if let expectedOpen = pairs[char] {     // char bir KAPANIŞ
            if stack.last == expectedOpen {
                stack.removeLast()               // eşleşti → pop
            } else {
                return false                     // eşleşmedi (veya stack boş) → geçersiz
            }
        } else {                                 // char bir AÇILIŞ
            stack.append(char)
        }
    }
    return stack.isEmpty                         // artakalan açılış varsa geçersiz
}
```
- **Time:** O(n) · **Space:** O(n) (worst: hepsi açılış)

**İnce noktalar:**
- `pairs[char]` nil ⇒ açılış, non-nil ⇒ kapanış. Tek sözlük iki işi görür.
- `stack.last` boş dizide **nil** döner → `nil == "["` false → **crash yok**. (`removeLast()` boşta crash eder ama buraya sadece eşleşme varken giriliyor.)
- Son `isEmpty` kontrolü `"((("` gibi kapanmayanları yakalar.

---

## 4. Trace
```
"{[]}"  { push[{] · [ push[{,[] · ] beklenen [ ✓ pop[{] · } beklenen { ✓ pop[] → true
"([)]"  ( push · [ push · ) beklenen ( ama tepe [ → FALSE
"]"     ) değil: beklenen [ , tepe nil → FALSE
```

---

## 5. Edge Cases
| Case | Sonuç | Neden |
|------|-------|-------|
| `"("` | false | stack dolu kalır |
| `"]"` | false | mismatch → erken false |
| `"()"` | true | push+pop, boş biter |
| `""` | true | döngü çalışmaz, isEmpty |

**Not:** Hiçbiri için özel guard gerekmez — algoritma doğal kapsar.

---

## 6. Common Mistakes — Personal Record

### Mistake 1 — "Sessiz yutma": mismatch'te hiçbir şey yapmamak (**2 kez**)
Kapanış tepedekiyle eşleşmeyince `if` çalışmıyor ve **başka bir dal yok** → karakter görmezden geliniyor. `"]"` ve `"()]"` yanlışlıkla `true` dönüyor.
**Kural:** Bir koşulun **her dalında** ne olacağını açıkça belirt. `if` yazdıysan `else`'i de düşün — "hiçbir şey yapma" bilinçli bir karar olmalı, kaza değil.

### Mistake 2 — **Yeniden yazma tuzağı (asıl ders)**
Kod %90 doğruydu, tek satır eksikti. Onu düzeltmek yerine **baştan yazdım** → iki ayrı döngülü bir versiyon çıktı; bu **stack'in özünü öldürdü** (tararken iç içe push/pop). İki geçişte `"([)]"` ile `"()[]"` ayırt edilemez — sıra bilgisi kaybolur. Ayrıca ikinci döngüdeki `guard let ... else { return false }` tüm açılışları eliyordu → `"()"` bile false.
**Kural:** Bir çözüm neredeyse doğruysa **boşluğu doldur, baştan yazma.** Hangi parçanın çalıştığını bilmek, yeni bir şey denemekten değerlidir.

### Mistake 3 — Gereksiz guard'lar
`guard s.count == 1`, `guard s.isEmpty` eklemiştim; algoritma bunları zaten doğal kapsıyor. Ayrıca `s.count` String'de **O(n)**.
**Kural (#485 ile aynı):** Edge case'i çözmeden önce ana mantığın onu kapsayıp kapsamadığına bak.

---

## 7. Reusable Pattern — Stack ile eşleştirme
```swift
var stack: [T] = []
for x in items {
    if kapanisMi(x) {
        guard stack.last == beklenen(x) else { return false }
        stack.removeLast()
    } else { stack.append(x) }
}
return stack.isEmpty
```
**Kardeşler:** Min Stack (155), RPN (150), Remove Adjacent Duplicates (1047), Daily Temperatures (739, monotonic).

---

## 8. Follow-up
- **"Min'i O(1) döndür"** → Min Stack: yardımcı stack ile her seviyenin min'ini tut.
- **"Sadece tek tür parantez"** → sayaç yeter, stack gerekmez (space O(1)).
- **"En uzun geçerli parantez alt dizisi (32)"** → stack'te **index** tut.

---

## 9. Re-solve
1. **+3 gün:** Sıfırdan, ≤ 6 dk. Mismatch dalını **unutma**.
2. **+1 hafta:** Min Stack (155).

## References
- [LeetCode #20](https://leetcode.com/problems/valid-parentheses/)
- Mekanik: `concepts/04-stack-queue.md`
