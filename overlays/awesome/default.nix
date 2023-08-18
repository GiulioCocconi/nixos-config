{...}:
final: prev:
{
  awesome = prev.awesome.override {
    lua = prev.luajit;
  };
}
