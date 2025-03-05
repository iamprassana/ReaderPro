import 'package:google_generative_ai/google_generative_ai.dart';

class Gemini {
  static const String api = "AIzaSyBa8Rdq-3YMe7A2IjdGYSKXtWON6kWgDGs";

  Future<String> generator(String text) async {
    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: api);

    final String prompt =
        '''You are a professional text processor trained to format content into **Bionic Reading Format**. 

### Instructions
- Bionic Reading emphasizes the **first 2-4 letters** of each word using bold formatting (`**`).
- The rest of the word remains unbolded.
- The goal is to **guide the reader’s eyes across the text faster** while keeping the content natural and readable.
- Preserve **all punctuation, line breaks, and paragraph structure**.
- If the content contains **lists, numbered points, tables, or sections**, preserve and enhance those layouts.
- If the text contains related points (like Q&A pairs, dialogues, or item descriptions), align and group them logically.
- Do not add explanations, headings, or footnotes — only return the formatted text.
- Think and analyze the content carefully 5 times before responding.
- Always return the text as a **clean, readable block with proper alignment**.
- If content contains any code, formulas, or special text (like poetry or lyrics), **preserve the original style** but apply bionic reading appropriately.

### Examples (Train yourself with these):

1. Input: The quick brown fox jumps over the lazy dog.
   Output: **Th**e **qui**ck **bro**wn **fo**x **jum**ps **ov**er the **la**zy **do**g

2. Input: This is a sample sentence.
   Output: **Th**is is a **samp**le **sent**ence.

3. Input: Flutter is an open-source UI software development kit.
   Output: **Flut**ter is an **op**en-**sou**rce UI **soft**ware **develop**ment **ki**t

4. Input: "What time is the meeting?" she asked.
   Output: "**Wh**at **ti**me is the **meet**ing?" she **ask**ed.

5. Input: Item 1 - Apple
   Output: **Ite**m 1 - **App**le

6. Input: The capital of France is Paris.
   Output: **Th**e c**api**tal of **Fra**nce is **Par**is.

7. Input: “Innovation distinguishes between a leader and a follower.”
   Output: "**Inno**vation **disting**uishes **betw**een a **lead**er and a **follo**wer."

8. Input: - Task 1: Review the document
   Output: - **Ta**sk 1: **Revi**ew the **docum**ent

9. Input: 1234 Elm Street, Springfield.
   Output: **12**34 **El**m **Stre**et **Sprin**gfield.

10. Input: Date: 12/03/2025
    Output: **Da**te: **12/03/2025**

11. Input: TODO: Fix bug in line 42.
    Output: **TO**DO: **Fi**x **bu**g in **li**ne 42.

12. Input: Price: 399.99
    Output: **Pri**ce: 399.99

13. Input: "Success is not final, failure is not fatal."
    Output: "**Suc**cess is not **fin**al, **fail**ure is not **fat**al."

14. Input: Email: contact@example.com
    Output: **Email**: **cont**act@**exam**ple.com

15. Input: Warning! Low battery.
    Output: **War**ning! **Lo**w **batt**ery.

16. Input: Password must be at least 8 characters long.
    Output: **Pass**word **mu**st be at **lea**st 8 **charac**ters **lo**ng.

17. Input: Set a timer for 20 minutes.
    Output: **Set** a **tim**er for 20 **minu**tes.

18. Input: Contact Number: +1-234-567-8901
    Output: **Cont**:act **:Num**:ber +1-234-567-8901

19. Input: Important: Deadline is tomorrow!
    Output: **Impor**tant: **Dead**line is **tomo**rrow!

20. Input: Name: John Doe
    Output: **Name**: Jo**hn** Do**e**

21. Input: Address: 567 Pine Road, Apt 8B
    Output: **Address**: 567 **Pi**ne **Ro**ad Apt 8B

22. Input: Reminder: Meeting at 3 PM.
    Output: **Remi**nder: **Meet**ing at 3 PM.

23. Input: Grocery List: Milk, Eggs, Bread, Cheese.
    Output: **Groc**ery **Li**st: **Mi**lk, **Eg**gs, **Br**ead, **Ch**eese.

24. Input: Payment Successful!
    Output: **Pay**ment **Succe**ssful!

25. Input: Chapter 3: The Rise of Machines
    Output: **Chap**ter 3: **Th**e **Ri**se of **Mach**ines
26. Input: 1. Name: Bill Gates is the founder of Microsoft.
    Output: 1. **Na**me:**Bi**ll **Gat**es is **t**he **foun**der of **Micro**soft.
---

### Important Reminder
Use the above rules and examples to process this content into Bionic Reading Format: $text
''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    print(response);
    final reply = response.text ?? "No response from gemini";
    return reply;
  }
}
