# 00 — CONCEPT NOTE TEMPLATE

> Her `concepts/NN-*.md` bu iskeleti izler. `01-array.md` ve `02-hashtable.md` bunun kanıtlanmış örnekleridir.
> **Kritik bölüm: "Mekanik (Under the Hood)"** — insert/search/delete'in arka planda nasıl çalıştığı ve Big-O'nun **neden** o olduğu. Retention'ın kalbi burası: sayıyı ezberleme, mekanizmadan türet.
> Yeni konu işlerken kopyala, `<...>` yerlerini doldur.

---

```markdown
# <Data Structure / Concept Adı>

## TL;DR
<2-3 cümle: bu nedir, arka planda fiziksel olarak ne (contiguous blok? node+pointer? bucket array?), ne için var.>

## Mekanik (Under the Hood) ← EN ÖNEMLİ
Her operasyonun **adım adım** nasıl çalıştığı ve **NEDEN** o complexity:
- **Access / lookup:** <mekanizma> → O(?) çünkü <sebep>
- **Search:** <mekanizma> → O(?) çünkü <sebep>
- **Insert:** <mekanizma; nerede ucuz nerede pahalı> → O(?) çünkü <sebep>
- **Delete:** <mekanizma> → O(?) çünkü <sebep>
- **Resize / rebalance / rehash** (varsa): <ne zaman tetiklenir, maliyeti>

> Amaç: whiteboard'da bu mekanizmayı çizebilmek. Çizebiliyorsan Big-O'yu ezberlemene gerek yok.

## Temel Invariant'lar
- <yapının her zaman koruduğu kurallar — ihlal edilirse yapı bozulur>

## Big O
| Operation | Average | Worst | Neden |
|-----------|---------|-------|-------|
| ... | ... | ... | ... |

(Sayıları [00-MASTER-COMPLEXITY.md](00-MASTER-COMPLEXITY.md) ile tut — çelişki olmasın.)

## Swift'e Özgü
- <stdlib nasıl implemente ediyor: Array, Dictionary, value type, CoW, vb.>

## Karar Motoru (ne zaman kullan / kaçın)
✅ Kullan: <sinyaller>
❌ Kaçın: <sinyaller — ve yerine ne>

## Trade-off / Kardeşlerle Karşılaştırma
<Array vs LinkedList, Dict vs Array, Heap vs BST gibi — ne zaman hangisi>

## Senior Sinyalleri / Terimler
- <mülakatta geçirince "bilir bu" dedirten terimler>

## Pattern Bağlantısı
<Bu yapı hangi problem sinyallerinde devreye girer — [00-PATTERN-TRIGGERS.md](00-PATTERN-TRIGGERS.md)>

## Yaygın Mülakat Problemleri
- [ ] <problem> (zorluk)

## Self-Quiz (recall kartları)
En az 5 soru. Bunlar [../retrieval/DECK.md](../retrieval/DECK.md)'e kart olarak eklenir.
1. Q: <...> → A: <...>
2. ...
```

---

## Neden bu bölümler (retention gerekçesi)

| Bölüm | Retention işlevi |
|-------|------------------|
| **Mekanik** | Türetilebilir bilgi ezberlenen bilgiyi yener; unutsan bile yeniden çıkarırsın |
| **Big-O + Neden** | Tablo tek başına unutulur; "neden" kalıcıdır |
| **Karar Motoru** | Bilgiyi *kullanıma* bağlar — mülakatta seçim anı |
| **Self-Quiz** | Aktif recall; deck'e beslenir, spaced repetition'a girer |
| **Pattern Bağlantısı** | Konuyu izole değil, problem tanımayla ilişkili tutar |
