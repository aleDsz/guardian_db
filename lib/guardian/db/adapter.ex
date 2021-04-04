defmodule Guardian.DB.Adapter do
  @moduledoc """
  The Guardian DB Adapter.

  This behaviour allows to use any storage system
  for Guardian Tokens.
  """

  @typep query :: Ecto.Query.t()
  @typep schema :: Ecto.Schema.t()
  @typep schema_or_changeset :: schema() | Ecto.Changeset.t()
  @typep queryable :: query() | schema()
  @typep opts :: keyword()

  @doc """

  """
  @callback one(queryable()) :: nil | schema()

  @doc """

  """
  @callback insert(schema_or_changeset()) :: {:ok, schema()}

  @doc """

  """
  @callback delete(schema_or_changeset()) :: {:ok, schema()}

  @doc """

  """
  @callback delete_all(queryable()) :: {:ok, pos_integer()}

  @doc """

  """
  @callback delete_all(queryable(), opts()) :: {:ok, pos_integer()}
end
