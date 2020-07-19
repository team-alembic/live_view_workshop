defmodule LiveViewWorkshopWeb.ClockView do
  use LiveViewWorkshopWeb, :view

  def format_datetime(datetime) do
    %DateTime{
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second
    } = datetime

    Integer.to_string(year) <>
      "/" <>
      pad_zero(month) <>
      "/" <>
      pad_zero(day) <>
      " " <>
      pad_zero(hour) <>
      ":" <>
      pad_zero(minute) <>
      ":" <>
      pad_zero(second)
  end

  defp pad_zero(number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
