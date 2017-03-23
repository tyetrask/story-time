class ToastyTown extends React.Component<{}, {}> {

    constructor() {
      super()
      this.toaster = {}
      this.refHandlers = {
        toaster: function (ref) { return this.toaster = ref; }
      };
    }

    componentDidMount() {
      this.toaster = Blueprint.Core.Toaster.create();
    }

    render() {
      return (
        <div>
          <Blueprint.Core.Button onClick={this.addToast.bind(this)} text="Procure toast" />
          <Blueprint.Core.Toaster {...{message: "hi"}} position={Blueprint.Core.Position.TOP_RIGHT} />
        </div>
      )
    }

    addToast() {
      this.toaster.show({ message: "Toasted!" });
    }
}

window.ToastyTown = ToastyTown;
