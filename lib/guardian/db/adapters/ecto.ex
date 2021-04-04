defmodule Guardian.DB.Adapters.Ecto do
  @moduledoc false

  @behaviour Guardian.DB.Adapter

  @impl true
  def one(queryable) do
    repo().one(queryable)
  end

  @impl true
  def insert(changeset = %Ecto.Changeset{}) do
    repo().insert(changeset)
  end

  def insert(schema = %{__meta__: %Ecto.Schema.Metadata{}}) do
    repo().insert(schema)
  end

  @impl true
  def delete(changeset = %Ecto.Changeset{}) do
    repo().delete(changeset)
  end

  def delete(schema = %{__meta__: %Ecto.Schema.Metadata{}}) do
    repo().insert(schema)
  end

  @impl true
  def delete_all(queryable) do
    delete_all(queryable, [])
  end

  @impl true
  def delete_all(queryable, opts) do
    repo().delete_all(queryable, opts)
  end

  defp repo do
    :guardian
    |> Application.get_env(Guardian.DB)
    |> Keyword.fetch!(:repo)
  end
end
