import { useState, useEffect } from "react";
import { mockArticles, mockCategories } from "../data/mockData";
import { Article, Category } from "../types";

// Toggle this flag depending on environment
const USE_MOCK = process.env.NODE_ENV !== "production";

export function useStaticData() {
  const [articles, setArticles] = useState<Article[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      if (USE_MOCK) {
        // 🔹 Development: mock data
        setArticles(mockArticles);
        setCategories(mockCategories);
        setLoading(false);
      } else {
        try {
          // 🔹 Production: fetch from Supabase
          const { data: articlesData, error: articlesError } = await fetch(
            "/api/articles" // replace with Supabase client call
          ).then((res) => res.json());

          const { data: categoriesData, error: categoriesError } = await fetch(
            "/api/categories" // replace with Supabase client call
          ).then((res) => res.json());

          if (articlesError || categoriesError) {
            throw new Error("Failed to fetch data");
          }

          setArticles(articlesData);
          setCategories(categoriesData);
        } catch (err) {
          console.error(err);
          // fallback: mock data if API fails
          setArticles(mockArticles);
          setCategories(mockCategories);
        } finally {
          setLoading(false);
        }
      }
    }

    fetchData();
  }, []);

  const getArticlesByCategory = (categorySlug: string) => {
    const category = categories.find((cat) => cat.slug === categorySlug);
    if (!category) return [];
    return articles.filter((article) => article.category_id === category.id);
  };

  const getFeaturedArticles = () => {
    return articles.filter((article) => article.is_featured);
  };

  const getArticleBySlug = (slug: string) => {
    return articles.find((article) => article.slug === slug);
  };

  return {
    articles,
    categories,
    loading,
    getArticlesByCategory,
    getFeaturedArticles,
    getArticleBySlug,
  };
}
