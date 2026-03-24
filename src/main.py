from llm import ask_llm
from prompt import build_sql_prompt
from validator import is_safe_sql, normalize_sql
from db import run_query
from random import choice
from explain import build_explanation_prompt

good_questions = [
    "Show the top 5 customers by total order amount",
    "List customers in the North region",
    "Show total revenue by customer",
    "Which customer placed the most recent order?"
]
bad_questions = [
    "Show all products with low inventory"
]


def main():

    question_type = input('Run a "good" query or a "bad" query? [g,b] ').strip()
    if question_type == 'g':
        user_question = choice(good_questions)
    else:
        user_question = choice(bad_questions)

    #user_question = input("What would you like me to query? ").strip()
    #user_question = "Show the top 5 customers by total order amount"


    # 1. Generate SQL
    prompt = build_sql_prompt(user_question)
    sql = ask_llm(prompt)
    sql = normalize_sql(sql)

    print("Generated SQL:")
    print(sql)
    print("\nQuestion")
    print(user_question)
    print("\n")

    # 2. Validate
    if sql is None or sql == "" or sql == "CANNOT_ANSWER":
        print("\n❌ Query cancelled")
        return

    is_safe, reason = is_safe_sql(sql)

    if not is_safe:
        print("\n❌ Unsafe SQL detected:")
        print(reason)
        return

    print("\n✅ SQL passed validation")

    # 3. Execute
    results = run_query(sql)

    print("\nResults: ")
    for row in results:
        print(row)

    # 4. Explain
    explanation_prompt = build_explanation_prompt(user_question, sql, results)
    explanation = ask_llm(explanation_prompt)

    print("\n🧠 Explanation:")
    print(explanation)

if __name__ == "__main__":
    main()
