import App from './_app';

// Minimal index page to ensure Next serves the root path.
// The main application UI and sign-in logic live in _app.js.
export default function IndexPage(props) {
  return App(props);
}
