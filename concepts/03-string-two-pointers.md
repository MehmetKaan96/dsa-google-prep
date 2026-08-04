# String & Two Pointers

> Referans özet. Mekanik = retention'ın kalbi (bkz [00-TEMPLATE](00-TEMPLATE.md)).

## TL;DR

**String** = grapheme cluster'lardan (Character) oluşan bir koleksiyon; karakterler **değişken byte** genişliğinde → **integer index yok** (`str[Int]` yasak). **Two Pointers** = iki index'i (genelde iki uçtan) hareket ettiren teknik; sıralı/simetrik problemlerde O(n) time, O(1) space.

## Mekanik (Under the Hood) — String (Swift)

- **Character = grapheme cluster:** insanın "tek karakter" gördüğü şey; değişken byte kaplar (`"a"`=1B, `"é"`=2B, `"😀"`=4B, `"👨‍👩‍👧‍👦"`=~25B tek Character).
- **Değişken genişlik → sabit stride YOK → `str[Int]` yasak.** Array'in O(1) erişimi eşit boyuttan (`base+i×stride`) geliyordu; string'de i. karakterin byte offset'i hesaplanamaz → baştan yürümek gerekir.
- **`count` = O(n):** byte sayısı O(1) bilinir ama **karakter** sayısı için grapheme cluster sınırlarını baştan sona yürümek gerekir.
- **`Array(s)` trade-off:** `[Character]`'a çevir → her slot uniform → **O(1) index** geri gelir, ama **O(n) time + O(n) space** bedeli. Index-yoğun/two-pointer string algoritmaları için buna değer.
- **`String.Index`:** `startIndex` (ilk), `endIndex` (**son+1, past-the-end, okunamaz**), `index(after:)`/`index(before:)` ile yürü, `s[idx]` oku. Comparable. O(1) space ama çetrefilli. Boş string'de `index(before: endIndex)` → crash, guard'la.

## Mekanik — Two Pointers

- **Converging (iki uçtan):** `left=0`, `right=n-1`, `while left < right`. Her tur bir uçtan içeri; mesafe 1 azalır → **O(n)**. **Sorted** veya simetri gerektirir (pair-sum, palindrome, container).
- **Fast & slow (aynı yön):** iki pointer farklı hızda — döngü tespiti, orta nokta, in-place dedupe. *(ileride)*
- **Skip-filter varyantı:** karşılaştırmadan bazı elemanları atla (Valid Palindrome'da non-alnum).

## Big O
| İşlem | Complexity | Neden |
|-------|-----------|-------|
| `str[Int]` | — (yasak) | değişken stride |
| String'de i. karaktere ulaş (Index) | O(n) | baştan yürü |
| `str.count` | O(n) | grapheme yürüme |
| `Array(str)` | O(n) time, O(n) space | tam kopya |
| Converging two pointers | O(n) time, O(1) space | her tur bir uç, mesafe↓ |

## Karar Motoru
✅ **Two pointers kullan:** sorted dizi + pair/karşılaştırma · palindrome/simetri · iki-uçtan optimize (container).
✅ **Array(s) kullan:** string'i index'le/two-pointer'la gezeceksen (O(n) space kabul).
✅ **String.Index kullan:** O(1) space şartsa.
❌ **Kaçın:** unsorted'da pair için two-pointer (sort O(n log n) gerekir; hash daha iyi olabilir).

## Senior Sinyalleri / Terimler
- Grapheme cluster · Unicode scalar · UTF-8/16 view · String.Index · past-the-end endIndex
- Converging vs fast-slow pointers · De Morgan (`!(A||B)=!A&&!B`)

## Pattern Bağlantısı
"sorted + pair" / "palindrome" / "iki-uçtan" → converging two pointers. Bkz [00-PATTERN-TRIGGERS](00-PATTERN-TRIGGERS.md).

## Yaygın Mülakat Problemleri
- [x] Two Sum II — Sorted (167) — converging
- [x] Valid Palindrome (125) — converging + skip + String mekaniği
- [ ] Reverse String (344) — two-pointer swap
- [ ] Container With Most Water (11) — converging greedy
- [ ] 3Sum (15) — sort + fix + two-pointer
- [ ] Valid Palindrome II (680) — skip 1 char
- [ ] Longest Substring Without Repeating (3) — sliding window

## Self-Quiz (deck: STR-*)
1. Q: `str[5]` neden yasak? → A: Character değişken byte, sabit stride yok, O(n) olurdu.
2. Q: `count` neden O(n)? → A: grapheme cluster sınırlarını baştan yürümek gerekir.
3. Q: `Array(s)` ne kazandırır/bedeli? → A: O(1) index; O(n) time+space.
4. Q: `endIndex` nedir? → A: son karakterin **bir sonrası** (okunamaz).
5. Q: Converging two pointers neden O(n)? → A: her tur bir uç içeri, mesafe 1↓, en fazla n adım.
